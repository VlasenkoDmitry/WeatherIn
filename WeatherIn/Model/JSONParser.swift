import Foundation

class JSONParser {
    func decode<T: Decodable>(data: Data, classRequest: T.Type) -> T?{
        let decoder = JSONDecoder()
        do {
            let result = try decoder.decode(classRequest, from: data)
            return result
        } catch {
            print(error)
        }
        return nil
    }
}
