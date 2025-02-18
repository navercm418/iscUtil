ClassMethod ZvGetQueryPlan(zvSqlQuery As %String, zvNamespace As %String = "") As %Status
{
    // Set the namespace if provided
    if zvNamespace'="" {
        znspace = ##class(%Library.Process).ChangeNamespace(zvNamespace)
        if $$$ISERR(znspace) {
            write "Error changing namespace: ", ##class(%SYSTEM.Status).GetErrorText(znspace), !
            quit znspace
        }
    }

    // Prepare the query
    set zvStatus = ##class(%SYSTEM.SQL).Execute("EXPLAIN " _ zvSqlQuery, .zvResultSet)
    if $$$ISERR(zvStatus) {
        write "Error preparing query: ", ##class(%SYSTEM.Status).GetErrorText(zvStatus), !
        quit zvStatus
    }

    // Fetch and print the query execution plan details
    while zvResultSet.%Next() {
        write "Plan: ", zvResultSet.%Get("Plan"), !
        write "Cost: ", zvResultSet.%Get("Estimated_Cost"), !
    }

    quit $$$OK
}
