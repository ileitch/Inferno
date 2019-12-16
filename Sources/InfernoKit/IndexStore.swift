import Foundation
import IndexStoreDB

class IndexStore {
    private let db: IndexStoreDB
    private let db2: IndexStoreDB2

    init(storeUrl: URL) throws {
        let lib = try IndexStoreLibrary(dylibPath: "/Applications/Xcode11.3.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/libIndexStore.dylib")
        let lib2 = try IndexStoreLibrary2(dylibPath: "/Applications/Xcode11.3.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/libIndexStore.dylib")
        let path = NSTemporaryDirectory() + "index_\(getpid())"


        self.db = try IndexStoreDB(
            storePath: storeUrl.path,
            databasePath: path,
            library: lib,
            listenToUnitEvents: true)

        self.db2 = try IndexStoreDB2(
            storePath: storeUrl.path,
            databasePath: path,
            library: lib2,
            listenToUnitEvents: true)
    }

    func allSymbolNames() -> [String] {
        return db2.allSymbolNames()
    }

    func get(name: String) -> [SymbolOccurrence] {
        var occurances: [SymbolOccurrence] = []

        let r2 = db.forEachCanonicalSymbolOccurrence(byName: name) { (o) -> Bool in
            occurances.append(o)
            return true
        }

        return occurances
    }
}

import CIndexStoreDB

public class IndexStoreLibrary2 {
  let library: indexstoredb_indexstore_library_t

  public init(dylibPath: String) throws {
    var error: indexstoredb_error_t? = nil
    guard let lib = indexstoredb_load_indexstore_library(dylibPath, &error) else {
      defer { indexstoredb_error_dispose(error) }
      throw IndexStoreDBError.loadIndexStore(error?.description ?? "unknown")
    }

    self.library = lib
  }

  deinit {
    indexstoredb_release(library)
  }
}


public final class IndexStoreDB2 {

  let impl: indexstoredb_index_t

  public init(
    storePath: String,
    databasePath: String,
    library: IndexStoreLibrary2?,
    readonly: Bool = false,
    listenToUnitEvents: Bool = true
  ) throws {

    let libProviderFunc = { (cpath: UnsafePointer<Int8>) -> indexstoredb_indexstore_library_t? in
      return library?.library
    }

    var error: indexstoredb_error_t? = nil
    guard let index = indexstoredb_index_create(storePath, databasePath, libProviderFunc, readonly, listenToUnitEvents, &error) else {
      defer { indexstoredb_error_dispose(error) }
      throw IndexStoreDBError.create(error?.description ?? "unknown")
    }

    impl = index
  }

  deinit {
    indexstoredb_release(impl)
  }

    func allSymbolNames() -> [String] {
        var names: [String] = []

        indexstoredb_index_symbol_names(impl) { (cString) -> Bool in
            names.append(String(cString: cString))
            return true
        }

        return names
    }

}
