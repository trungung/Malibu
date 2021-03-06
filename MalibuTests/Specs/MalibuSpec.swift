@testable import Malibu
import Quick
import Nimble

class MalibuSpec: QuickSpec {

  override func spec() {
    describe("Malibu") {
      let baseUrlString = "http://hyper.no"
      let surferNetworking = Networking(baseUrl: baseUrlString)

      beforeEach {
        Malibu.networkings.removeAll()
        Malibu.register("surfer", networking: surferNetworking)
      }

      describe(".mode") {
        it("is regular by default") {
          expect(Malibu.mode).to(equal(Malibu.Mode.regular))
        }
      }

      describe(".register:networking") {
        it("adds new networking instance with a name") {
          expect(Malibu.networkings.count).to(equal(1))
          expect(Malibu.networkings["surfer"]?.baseUrl?.urlString).to(equal(baseUrlString.urlString))
          expect(Malibu.networkings["surfer"]?.requestStorage.key).to(equal("\(RequestStorage.domain).surfer"))
        }
      }

      describe(".unregister") {
        it("removed a networking instance by name") {
          expect(Malibu.networkings.count).to(equal(1))

          Malibu.unregister("surfer")

          expect(Malibu.networkings.count).to(equal(0))
        }
      }

      describe(".networking") {
        context("when there is a networking registered with this name") {
          it("returns registered networking") {
            expect(networking("surfer") === surferNetworking).to(beTrue())
          }
        }

        context("when there is no networking registered with this name") {
          it("returns default networking") {
            Malibu.unregister("surfer")
            expect(networking("surfer") === Malibu.backfootSurfer).to(beTrue())
          }
        }
      }

      describe(".register:mock") {
        it("registers mock for the provided method on default networking") {
          let request = GETRequest()
          let mock = Mock(request: request, response: nil, data: nil, error: nil)

          Malibu.register(mock: mock)

          expect(Malibu.backfootSurfer.mocks["GET http://hyper.no"] === mock).to(beTrue())
        }
      }
    }
  }
}
