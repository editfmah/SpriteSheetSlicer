import Foundation
import Cocoa

print("Sprite Slicer")

if CommandLine.arguments.count == 1 {
    print("No input image specified")
    exit(1)
}

print("Input pixel size of tile: ")
if let size = Int(readLine() ?? "") {
    print("Filename Prefix: ")
    if let prefix = readLine(), prefix.count > 0  {
        if let image = NSImage(contentsOfFile: CommandLine.arguments[1]) {
            
            func cropImage(image: NSImage, tileSize: Int) -> [NSImage?]? {
                let hCount = Int(image.size.height) / tileSize
                let wCount = Int(image.size.width) / tileSize

                var tiles:[NSImage?] = []

                for i in 0...hCount-1 {
                    for p in 0...wCount-1 {
                        let rect = CGRect(x: p*tileSize, y: i*tileSize, width: tileSize, height: tileSize)
                        if let temp:CGImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil)?.cropping(to: rect) {
                            tiles.append(NSImage(cgImage: temp, size: NSSize(width: tileSize, height: tileSize)))
                        } else {
                            tiles.append(nil)
                        }
                        
                    }
                }
                return tiles
            }
            
            if let images = cropImage(image: image, tileSize: size) {
                print("Exporting images")
                for index in 0...images.count-1 {
                    if let image = images[index] {
                        if let imageRep = NSBitmapImageRep(data: image.tiffRepresentation!) {
                            if let pngData = imageRep.representation(using: .png, properties: [:]) {
                                let fileName = "\(prefix)\(("000000\(index)".suffix(4)))"
                                print("Exporting file \(fileName)")
                                try pngData.write(to: URL(fileURLWithPath: fileName))
                            }
                        }
                    }
                }
            }
            print("Finished")
            exit(0)
        } else {
            print("unable to open input image '\(CommandLine.arguments[1])'")
            exit(1)
        }
    }
}
exit(1)
