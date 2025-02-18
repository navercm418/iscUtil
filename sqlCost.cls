ClassMethod ZvGetQueryCost(zvSqlQuery As %String) As %Status
{
    // Prepare the query
    set zvStatus = ##class(%SYSTEM.SQL).Execute("EXPLAIN " _ zvSqlQuery)
    if $$$ISERR(zvStatus) {
        write "Error preparing query: ", ##class(%SYSTEM.Status).GetErrorText(zvStatus), !
        quit zvStatus
    }

    // Execute the query
    set zvRs = ##class(%ResultSet).%New()
    set zvStatus = zvRs.Prepare("EXPLAIN " _ zvSqlQuery)
    if $$$ISERR(zvStatus) {
        write "Error preparing query: ", ##class(%SYSTEM.Status).GetErrorText(zvStatus), !
        quit zvStatus
    }

    set zvStatus = zvRs.Execute()
    if $$$ISERR(zvStatus) {
        write "Error executing query: ", ##class(%SYSTEM.Status).GetErrorText(zvStatus), !
        quit zvStatus
    }

    // Fetch and print the query cost details
    while zvRs.Next() {
        write "Cost: ", zvRs.Get("Cost"), !
        write "Plan: ", zvRs.Get("Plan"), !
    }

    quit $$$OK
}
