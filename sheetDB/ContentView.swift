//123
//  ContentView.swift
//  sheetDB
//
//  Created by A2006 on 2021/9/8.
//

import SwiftUI

struct ContentView: View {
    @State private var ListArray = [DrinksInformation]()
    var items = [Item]()
    @State private var text = ""
    var body: some View {
       
        ScrollView(.vertical ,showsIndicators : false){
            ForEach(ListArray, id: \.self) { comp in
                Text("\(comp.name)")
                Text("\(comp.drinks)")
                Text("\(comp.size)")
                Text("\(comp.sugar)")
                Text("\(comp.ice)")
                Text("\(comp.price)")
                    
                .padding()
            }
        }
        .border(Color.purple, width: 1)
        Button(action: {

            
            let urlString = "https://sheetdb.io/api/v1/ygvhqoxp8oljv"
            
            let url = URL(string: urlString)
            var urlRequest = URLRequest(url: url!)
            urlRequest.httpMethod = "POST"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            
            let item = Item(name: "安安", drinks: "紅茶", size: "中杯", sugar: "半糖", ice: "少冰", price: "35", message: "")
            
            let itemdata = ItemData(data: [item])
            let encoder = JSONEncoder()
            if let data = try? encoder.encode(itemdata) {
                let task = URLSession.shared.uploadTask(with: urlRequest, from: data) { (returnData, response, error) in
                    let decoder = JSONDecoder()
                    
                    if let returnData = returnData,
                        let dic = try? decoder.decode([String: Int].self, from: returnData),
                        dic["created"] == 1 {
                    }else{
                        print ("if let returnData = retrnData fail")
                    }
                }
                task.resume()
            }else {
                print("encode fail")
            }
            
        }, label: {
            Text("Creat")
        })

        
        Button(action: {
            let deleteUrlString = "https://sheetdb.io/api/v1/ygvhqoxp8oljv/name/ggg"
                   //在api後面加上欄位跟值
                   if let urlString = deleteUrlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),let url = URL(string: urlString) {
                       var request = URLRequest(url: url)
                    //設定HTTP方法為deleted
                       request.httpMethod = "DELETE"
                       request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                        let task = URLSession.shared.dataTask(with: request) { (returnData, response, error) in
                            let decoder = JSONDecoder()
                            if let returnData = returnData, let dictionary = try? decoder.decode([String: Int].self, from: returnData), dictionary["deleted"] == 1{
                                             print("Delete successfully")
                             }else{
                                 print("Delete failed")
                             }
                        }
                    task.resume()
                    }
        }, label: {
            Text("deleted")
        })

        Button(action: {
            
            let url = URL(string: "https://sheetdb.io/api/v1/ygvhqoxp8oljv/name/安安".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)//在api後面加上欄位跟值
            var request = URLRequest(url: url!)
               request.httpMethod = "PUT"
               request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let item = Item(name: "ggg", drinks: "ggg", size: "ggg", sugar: "ggg", ice: "ggg", price: "ggg", message: "ggg")
            let ordertoupload = ItemData(data: [item])
            
            let jsonencoder = JSONEncoder()
            if let data = try? jsonencoder.encode(ordertoupload){
                let task = URLSession.shared.uploadTask(with: request, from: data) { (returnData, response, error) in
                    let decoder = JSONDecoder()
                    if let returnData = returnData,let dictionary = try? decoder.decode([String: Int].self, from: returnData), dictionary["updated"] == 1{
                                     print("updated successfully")
                                 }else{
                                     print("updated failed")
                                 }
                             }
                task.resume()
            }
        }, label: {
            Text("updata")
        })
        
        Button(action: {
           
            ListArray = []
            
            
            let urlStr = "https://sheetdb.io/api/v1/ygvhqoxp8oljv".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
//        let urlStr = "https://sheetdb.io/api/v1/co2xognew7ev0".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            // 將網址轉換成URL編碼（Percent-Encoding）
            let url = URL(string: urlStr!) // 將字串轉換成url
            
            // 背景抓取飲料訂單資料
            let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
                if let data = data, let content = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [[String: Any]]{
                    // 因為資料的Json的格式為陣列（Array）包物件（Object），所以[[String: Any]]
                    
                    for order in content {
                        if let data = DrinksInformation(json: order){
                            ListArray.append(data)
                        }
                    }
                }
            }
            task.resume() // 開始在背景下載資料
        }, label: {
            Text("get")
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct ItemData: Codable {
    var data: [Item]
}


struct Item: Codable {
    
    var name: String
    var drinks: String
    var size: String
    var sugar: String
    var ice: String
    var price: String
    var message: String
    
}




struct DrinksInformation : Codable,Hashable{
    var name: String
    var drinks: String
    var size: String
    var sugar: String
    var ice: String
    var price: String
    var message: String
        
        
    init?(json: [String : Any]) {
        guard let name = json["name"] as? String,
            let drinks = json["drinks"] as? String,
            let size = json["size"] as? String,
            let sugar = json["sugar"] as? String,
            let ice = json["ice"] as? String,
            let price = json["price"] as? String,
            let message = json["message"] as? String
                
            else {
                return nil
            }
            self.name = name
            self.drinks = drinks
            self.size = size
            self.sugar = sugar
            self.ice = ice
            self.price = price
            self.message = message
         
    }
    
}
