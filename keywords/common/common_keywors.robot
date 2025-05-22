*** Keywords ***
Set test data number
    [Arguments]    ${test_data_number}
    BuiltIn.Set test variable  ${testcase_number}  ${test_data_number}
    
Convert String List To Dictionary
    [Arguments]  ${string_list}
    ${result_dict}  BuiltIn.Create dictionary
    FOR  ${item}  IN  @{string_list}
        ${parts}  String.Split string   ${item}  :
        ${key}    BuiltIn.Set variable  ${parts}[0]
        ${value}  BuiltIn.Set variable  ${parts}[1]
        Collections.Set To Dictionary   ${result_dict}  ${key}  ${value}
    END
    RETURN  ${result_dict}