struct Item: Hashable, CustomStringConvertible {
    var count: Int
    let name: String

    init(_ count: Int, _ name: String) {
        self.count = count
        self.name = name
    }

    init(_ string: String) {
        let value = string.components(separatedBy: " ")
        self.count = Int(value.first!) ?? 0
        self.name = value.last!
    }

    var description: String {
        get {
            return "\(count) \(name)"
        }
    }

    func scaled(by scale: Int) -> Item {
        return Item(count * scale,name)
    }
}
struct Reaction {
    var inputs: [Item]
    var output: Item
}
var reactions = input.map { line in
    Reaction.init(inputs: line.first.map { $0.map{ Item($0) }}!, output: Item(line.last!.first!))
}

func cost(_ count: Int) -> Int {
    var req: [Item] = [Item.init(count, "FUEL")]
    var excess: [String: Int] = [:]
    var done = false

    while !done {
        //print(req)
        if !req.contains(where: { $0.name != "ORE"}) {
            done = true
        }
        var next: [Item] = []
        for item in req {
            if item.name == "ORE" {
                excess["ORE", default: 0] += item.count
            }
            else {
                //print(excess)
                var quantity = item.count
                if let extra = excess[item.name] {
                    if extra > quantity {
                        excess[item.name, default: 0] = extra - quantity
                        continue
                    } else {
                        quantity -= extra
                        excess.removeValue(forKey: item.name)
                    }
                }
                let current = reactions.filter{ $0.output.name == item.name }.first!
                let scale = Int(ceil(Double(quantity) / Double(current.output.count)))
                current.inputs.map { i in
                    var x = i
                    x.count *= scale
                    next.append(x)
                }

                let a = current.output.count * scale - quantity
                if a > 0 {
                    excess[item.name, default: 0] += a
                }
            }
        }
        req = next
    }
    //print(excess)
    return req.filter { (item) -> Bool in
        item.name == "ORE"
    }.first?.count ?? 0 + (excess["ORE"] ?? 0)
}

func partOne() {
    let result = cost(1)
    print("Part 1 answer is :\(result)")
}

func partTwo() {
    var low = 0
    var high = Int(1e12)
    while low < high {
        let mid = (low + high + 1) / 2

        if cost(mid) <= Int(1e12) {
            low = mid
        }
        else {
            high = mid - 1
        }
    }

    print("Part 2 answer is :\(low)")
}

partOne()
partTwo()