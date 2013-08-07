This library aims to provide the underlying data management and tools needed
to make working RP addons possible.  The intent is that any RP addon can be
done in terms of this library, and then they'll all be compatible.

The underlying communications are farmed out to LibRarian.  Right now that's
just using Message.Send to talk, but the intent is that it will eventually
also be smart enough to stash things in storage to reduce bandwidth use.
That change should be invisible to users...

Quick summary:

     Generic addon for exchanging RP data.

     {
       prefix = "",
       override = "",
       suffix = "",
       title = "",
       description = "",
       biography = "",
       meta = "",
       flags = "",
       version = "",
     }

     snoop(char, callback, query)
     	=> calls callback(char, data, error)
	If query is true, always query.  If query is false, never query.
	Otherwise, tries to use cached data if it's under a minute old,
	and uses cached data if a query fails.  WARNING:  If you want to
	mess with the table, copy it!  I am not copying tables.

     flaunt(table)
     flaunt(field, value)
     	=> Sets data about this character.  If the argument is a table,
	it's treated as { field = value } pairs.  A boolean false clears
	a value.

     setflag(c, state)
        => Sets the given flag (or unsets it if state is false), returning
	any flags which were unset as a result.  Note:  For purposes
	of this function, 'nil' is a kind of true; you must use an
	explicit false to unset a flag.  This sets a special 'editing' flag
	set (to allow you to edit flags non-destructively).  To save it,
	flaunt('flags').

     info()
        => displays info about character

     list(flags)
        => a list of characters currently known. If flags is a string of
	   flags, only characters with all of those flags are returned.

     fields()
        => a list of fields currently known.
		field = {
		  max = n,
		  help = "description",
		}
	Again, NOT A COPY.  Copy it before you change it.

     flags()
        => table, string
	Table is a list of known flags, string is a canonical sorted order
	for the flags.
	Again, NOT A COPY.  Do not change this.
		character => { name =, description =, excludes = }

     prettyname(name, data)
        => A prettied up string from the prefix, override, and suffix fields.

