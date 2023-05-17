//
//  ReadJSON.swift
//  macos_Camera
//
//  Created by Peter Rogers on 02/05/2023.
//

import Foundation
import Vision



class SentenceCreator: ObservableObject{
    @Published var sentences = "Nothing to see here."
    @Published var story = "...."
    @Published var isLoading = false
    weak var delegate: JSONDelegate?
 
    let qrSentences = [
    qrSentence(text: "Fumes invaded the air, a noxious veil that choked, a haunting reminder of destruction, a sorrow invoked ", id: "1"),
    qrSentence(text: "From blown-up bombshells, emerged birds in flight rising from the wreckage, a symbol of hope's might ", id: "2"),
    qrSentence(text: "Like fireworks, birds exploded in a dance of grace a midst the chaos, their presence a solace in that desolate place ", id: "3"),
    qrSentence(text: "The rubbles, stones, and bricks of shattered home's remains, the village was unrecognisable ", id: "4"),
    qrSentence(text: "Abandoned cars lay hidden under debris's shroud, a ghostly reminder of a once-joyous place ", id: "5"),
    qrSentence(text: "Birds picked up the bombs, defusing danger with care saving lives with their courage ", id: "6"),
    qrSentence(text: "amidst the turmoil some found refuge in the village's nooks and crannies waiting for peace to prevail ", id: "7"),
    qrSentence(text: "Bugs crawled around, scavenging amongst the debris, ", id: "8"),
    qrSentence(text: "Murmurations swirled above, a ballet in the sky, a mesmerising display, as birds soared high ", id: "9"),
    qrSentence(text: "Planes flew across the sky, shrouding it with smoke, ", id: "10"),
    qrSentence(text: "Bird-shaped rockets streaked across the horizon, a surreal sight, a war-torn land's painful raison ", id: "11"),
    qrSentence(text: "Ants invaded the fields we once played marching forward with unwavering aid ", id: "12"),
    qrSentence(text: "Planes dropped birds by thousands, a hopeful flight a message of peace, a beacon of light ", id: "13"),
    qrSentence(text: "Rockets scattered around the village waiting to be sent into the heavens ", id: "14"),
    qrSentence(text: "Birds guarded the village and fields with unwavering might protecting them from harm ", id: "15")
    
    ]
  
    func generateSentence(qrcodes: [VNBarcodeObservation]){
        sentences = ""
        for q in qrcodes{
            if let s = q.payloadStringValue{
                print(s)
                if let str = qrSentences.first(where: { $0.id == s }) {
                    sentences = sentences + str.text
                }
            }
           // sentences = sentences + (q.payloadStringValue ?? " ")
            //print(q.payloadStringValue)
        }
    }
    
    func makeQuery(myQuery:String){
        self.story = "Talking to the AI..."
        isLoading = true
        
        let headers = [
            "accept": "application/json",
            "content-type": "application/json",
            "X-API-KEY": "4cfe954a-a48e-4d47-b29b-b52b077409dd"
        ]
        let parameters = [
            "description": myQuery,
            "tone_of_voice": "childrens story, tale"
        ] as [String : Any]
        do{
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            
            let request = NSMutableURLRequest(url: NSURL(string: "https://api.writesonic.com/v2/business/content/story-generation?num_copies=1")! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 30.0)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            request.httpBody = postData as Data
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    print(error as Any)
                } else {
                   // let httpResponse = response as? HTTPURLResponse
                    //print(httpResponse)
                    //print(response.debugDescription)
                    do {
                        
                        
                        let str = String(decoding: data!, as: UTF8.self)
                        print(str)
                        let stories = try JSONDecoder().decode([Story].self, from: data!)
                        let jsonObject = stories.first
                       
                        DispatchQueue.main.async {
                            self.story = jsonObject?.text ?? "nothing found"
                            let output = jsonObject?.text ?? "nothing found"
                            Task {
                                await self.delegate?.didReceiveJSON(output)
                                }
                            
                            self.isLoading = false
                        }
                        
                    } catch {
                        print("Unable to decode JSON: \(error)")
                        DispatchQueue.main.async {
                            self.story = "There has been an error decoding data from the server.\n Make sure everything is connected and try again."
                            Task {
                                await self.delegate?.didReceiveJSON(self.story)
                                }
                            self.isLoading = false
                        }
                        
                    }
                }
            })
            
            dataTask.resume()
        }catch{
            
        }
    }
}

struct Story: Codable {
    let text: String
}

struct qrSentence{
    let text:String
    let id:String
}

protocol JSONDelegate: AnyObject {
    func didReceiveJSON(_ data: String)async
}
