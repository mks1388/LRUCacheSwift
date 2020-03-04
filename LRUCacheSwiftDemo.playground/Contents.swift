class LRUCache<T: Hashable & Equatable> {
    
    private var maxSize: Int = 0
    private var linkedList = LRUDoublyLinkedList<T>()
    private var cache: [T: LRUDoublyLinkedListNode<T>] = [:]
    private var count: Int = 0
    
    init(size: Int) {
        self.maxSize = size
    }
    
    func addItem(item: T) {
        if let node = cache[item] {
            removeNode(node)
        } else if count == maxSize {
            removeNode(linkedList.head!)
        }
        addNewNode(item)
    }
    
    func allItems() -> [T] {
        var arr = [T]()
        var node = linkedList.tail
        while node != nil {
            arr.append(node!.value)
            node = node!.previous
        }
        return arr
    }
}

// MARK: - Private
private extension LRUCache {
    func removeNode(_ node: LRUDoublyLinkedListNode<T>) {
        cache.removeValue(forKey: node.value)
        
        node.previous?.next = node.next
        node.next?.previous = node.previous
        
        if node == linkedList.head! {
            linkedList.head = node.next
        }
        if node == linkedList.tail! {
            linkedList.tail = node.previous
        }
        
        node.next = nil
        node.previous = nil
        
        if count > 0 {
            count -= 1
        }
    }
    
    func addNewNode(_ item: T) {
        let node = LRUDoublyLinkedListNode(value: item)
        
        node.previous = linkedList.tail
        linkedList.tail?.next = node
        
        linkedList.tail = node
        
        if linkedList.head == nil {
            linkedList.head = node
        }
        
        cache[node.value] = node
        
        count += 1
    }
}

// MARK: - Node
private final class LRUDoublyLinkedListNode<T: Equatable> {
    var value: T
    
    weak var next: LRUDoublyLinkedListNode?
    weak var previous: LRUDoublyLinkedListNode?
    
    init(value: T) {
        self.value = value
    }
}

extension LRUDoublyLinkedListNode: Equatable {
    static func == (lhs: LRUDoublyLinkedListNode<T>, rhs: LRUDoublyLinkedListNode<T>) -> Bool {
        return lhs.value == rhs.value
    }
}

// MARK: - Doubly LinkedList
private final class LRUDoublyLinkedList<T: Equatable> {
    typealias Node = LRUDoublyLinkedListNode<T>
    
    var head: Node?
    var tail: Node?
}


//Testing LRU
let stream = ["a", "b", "a", "c", "d", "b", "a", "s", "a"]
let lru = LRUCache<String>(size: 3)
for item in stream {
    lru.addItem(item: item)
    print("Items in cache -------------")
    for item in lru.allItems() {
        print(item)
    }
    print("----------------------------")
}
