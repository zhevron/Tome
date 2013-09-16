LibRarian is a general purpose data store, which will eventually try to
use *.Storage.* but doesn't yet.

     LibRarian.store(identifier, access, data, push_to_server)
        stores data in local savedvariables.
	if data == nil, removes local data
	if push_to_server is true, also uses Command.Storage.Set/Clear.

	if data is not a string, serializes it. This won't work with older
	LibRarian versions -- but conveniently those will stop existing once
	the old event model stops working.

     LibRarian.retrieve(target, identifier, callback, server_only)
        attempts to retrieve identified data from target, calling
     	callback(target, identifier, data, error)
	If data is not nil, then error is nil.  If data is nil, and
	error is also nil, the intent was actually to represent a nil
	value.

	Will only check Storage if server_only is provided/set. This
	includes not using local (LibRarian stash) data.

     LibRarian.info()
        yields a table of { id, data, access, access_count } for the
	local storage.

     LibRarian.zip(data)
     LibRarian.unzip(data)
     	Trivially compress/decompress data using zlib.

     The sneaky part:  Both store and retrieve may, at their discretion,
     try to use the *.Storage.* API.  The only real guarantee here is that
     if an identifier is already in the storage system, LibRarian will
     either replace it or remove it when replacing that identifier.

     LibRarianData holds the data; please don't mess with it.
