
### 오픈 마켓 프로젝트  
---  
  
팀원 : 루얀, 엘렌  

기간 : 2021년 8월 9일 → 2021년 8월 27일(진행중)


### 실행 화면
![open](https://user-images.githubusercontent.com/57824307/130350375-b1f317d7-892a-453a-bd7b-62eafff75db5.gif)



#### 프로젝트 UML  
---
#### 변경 전
<br>

![Untitled (1)](https://user-images.githubusercontent.com/57824307/129960365-26b40001-8d2c-425a-943c-68943b0366f5.png)
#### 변경 후
<br>

`HttpMethod`가 서버 API 문서의 요청에 따라 결정된다고 판단해 `HttpInfo` 내부 구현을 진행했는데, 서버 API가 호출되지 않더라도 `HttpMethod`는 존재해야하기 때문에 외부 `Enum` 타입으로 변경하였습니다.  
`networkHandler`가 `session`을 주입하는 형태로 진행하게 되면, 독립적인 테스트가 가능해지고, 의존 관계가 프로토콜로 역전되기 때문에 `sessionable`을 주입하는 형태로 코드 구성을 변경하였습니다.


![130207331-a68bf8e7-34fa-4f79-97fe-ea82d0d39c16](https://user-images.githubusercontent.com/57824307/130315097-ef25641b-c047-4f80-ac70-ff6d0e7b0207.png)

P.O.P에 대한 학습을 위해 HttpBody 프로토콜을 만들고, 이를 채택한 `MultipartForm`이나 `JsonObject` 타입을 구현해, `NetworkHandler`는 `HttpBody`을 의존하도록 프로젝트 방향을 설정했습니다.

서버 API 문서에서 유저의 요청 URL이 들어오면, 이에 따른 `HttpMethod`이 매칭되야 한다고 생각해서 `HttpInfo` 내부에 중첩 타입으로 구현했습니다.


객체 간의 의존 관계가 생기는 것을 방지하기 위해 프로토콜를 선언하고 활용해 코드를 작성했습니다. 복잡도가 높아지는 결과를 가져올 순 있지만, 코드를 관리하는 관점에서 효율적이지 않을까 생각합니다.




#### Issue & What I Learn

---

**기존에 공부한 내용을 바탕으로 프로젝트를 진행하면서 발생 가능한 문제점과 학습해야할 사항을 미리 정리해보았습니다.**

1. 실제 서버 통신과 무관한 UnitTest

<details>
  <summary> 의존성 주입을 통한 Mock 활용 </summary>
  <div markdown="1">    
  

```swift
      protocol Bable {
        var aaa: Int {get set}
        func amount() -> Int
      }

      class A {
        private let b: Bable // b라는 값을 의존하고 있음.

        init(b: Bable) {
          self.b = b
        }

        // 1 인 경우에만 true를 return 해주는 것을 test 해보고 싶음.
        func isValid() -> Bool {
          return b.amount == 1
        }
      }

      // Test를 위한 BMock
      class BMock: Bable {
        private var aaa: Int = 1
        func amount() -> Int {
          return aaa;
        }
      }
```

  </details>



2. 셀의 이미지 지연 로딩 및 뷰의 재사용 문제
<details>
<summary> 셀 이미지 지연 로딩 / 뷰의 재사용 </summary>
<div markdown="1">    

1. **각 섹션의 3번 줄은 빨간색 배경을 가진 셀을 표시.** 해당 셀을 reuse하게 될 경우, 빨간색 배경이 설정된 채 reusable queue에 들어가게 된다. 따라서 셀이 reuse되기 전에 cell에 대한 초기화 작업을 진행해야 한다.

   ```swift
   override func prepareForReuse() {
           self.backgroundColor = .white
           sectionLabel.text = nil
           rowLabel.text = nil
           customImage.image = nil
       }
   ```

   Cell은 prepareForReuse() 메소드를 가지고 있고, 해당 메소드에 대한 정보는 하단과 같다.

   ### **prepareForReuse()**

   Prepares a reusable cell for reuse by the table view's delegate.

   UITableView가 reuse identifier을 가질 경우, UITableView의 메소드인 dequeueReusableCell(with Identifier:) 메서드를 호출하기 직전에 이 메소드가 실행된다.

   잠재적인 성능 이슈를 피하기 위해 개발자 문서는 다음을 요청한다.

   To avoid potential performance issues, you should only reset attributes of the cell that are not related to content, for example, alpha, editing, and selection state.

   TableView(_: cellForRowAt:) 메서드는 재사용할 때 모든 content를 초기화해야 한다.

   cell의 배경 또한, alpha의 값과 동일한 시각에서 바라본다면, content에 포함되지 않는다는 생각이 든다.

   **이 메서드를 재정의할 경우 superclass의 구현을 호출해야 한다.**

2. **스크롤 시 버벅이는 증상**

   ```swift
   guard let imageURL = URL(string: imageURL[indexPath.row]) else { fatalError() }
   URLSession.shared.dataTask(with: URLRequest(url: imageURL)) { data, response, error in
       guard let data = data, error == nil else { return }
       let image = UIImage(data: data) // main에서 하지 말기
       DispatchQueue.main.async {
           cell.customImage.image = image
       }
   }.resume()
   ```

   URLSession에 dataTask를 활용해 url에 imageURL을 요청했고, 클로저 내부에서 data를 UIImage로 형변환 작업을 진행한다. 기존 코드에서 data → UIImage로 변환하는 과정에서 많은 부하가 걸릴 수 있다는 것을 인지하지 못하고, DispatchQueue.main에서 해당 부분을 작성했음.

   ```swift
       DispatchQueue.main.async {
           cell.customImage.image = UIImage(data: data)
       }//UIImage(data: data) 는 main에서 할 일이 아님!
   // 단순히 cell.customImage.image = image 처럼 할당만 해주는 코드로 변경해야 한다.
   ```

3. 스크롤 시 원하지 않는 위치에 비동기 처리를 요청한 이미지가 출력되는 증상

스크롤을 했을 경우, 비동기적으로 동작을 요청한 url로부터 이미지 수신 과정에서 실제 내가 값을 할당하려는 cell의 indexPath가 이후에 바뀌게 되고, 따라서 원치 않는 위치에 이미지들이 출력되는 증상이 있었다.

```swift
guard let imageURL = URL(string: imageURL[indexPath.row]) else { fatalError() }
URLSession.shared.dataTask(with: URLRequest(url: imageURL)) { data, response, error in
    guard let data = data, error == nil else { return }
    let image = UIImage(data: data) 
    DispatchQueue.main.async {
    //  indexPath 복사 캡쳐
    //  tableview, tableViewCell(ref Type) : ref counting++, Strong ref
    //  closure 실행 시점에 참조되고 있음.
    //  if 캡쳐(과거)시점의 indexPath == closure 실행 시점의 tableView에게 얻은 cell의 위치 -> 화면 안에 있으면 출력한다.
        if indexPath == tableView.indexPath(for: cell) {
            cell.customImage.image = image
        }
    }
}.resume()
```

URLSession.shared.dataTask(with: completionHandler: )의 complietionHandler에 해당하는 클로저의 캡쳐를 통해 해당 문제를 해결 했다.

```swift
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? CustomTableViewCell else { fatalError() } 
```
  
![image](https://user-images.githubusercontent.com/57824307/129961585-8f79e809-1346-43d2-b340-703fb2a995c7.png)


tableView(_ tableView, cellForRowAt indexPath:) → UITableViewCell 메서드에서 dataTask(with: URLRequest(url: imageURL)의 클로저는 cell, tableView, indexPath를 캡쳐하고 있으며, 클로저가 종료될 때까지 참조가 유지된다. 여기서 tableView나 cell은 class 타입에 속하고, indexPath 는 구조체에 속한다.  네트워크 요청을 성공적으로 마쳤다고 가정하고, `DispatchQueue.main.asnyc` 내에서 조건문으로 들어왔다고 가정한다.

`if indexPath == tableView.indexPahth(for: cell)` 의 조건문을 판별하게 되는데,

indexPath 는 클로저가 과거 캡쳐 시점 복사를 통한 캡쳐한 값을 의미하고,

tableView.indexPaht(for: cell)의 결과는 사용자와의 상호작용으로 인해 변경되거나, 기존 상태를 유지하는 indexPath를 의미한다. 해당 조건문이 참일 경우, 클로저의 실행 시점에서 tableView로부터 전달받은 특정 cell의 위치가 화면 안에 있음을 의미하고, 거짓인 경우, cell이 더이상 화면에 존재하지 않음을 의미한다.

따라서 indexPath의 비교를 통해 실제 비동기 작업의 UI 반영 여부를 결정할 수 있게 된다.







