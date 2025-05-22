*** Keywords ***
Open demoqa web browser
    cpwebcommon.Open chrome browser            ${url.demoqa}
    SeleniumLibrary.Page Should Contain Image  ${main_page.image_toolsqa}

Open element page
    Element_feature.Open demoqa web browser
    SeleniumLibrary.Scroll Element Into View  ${main_page.btn_bsa}
    cpwebcommon.Click element when ready      ${main_page.btn_elements}

Verify text box success
    [Arguments]  ${expect_result}
    ${elements}       SeleniumLibrary.Get WebElements  ${element_manu_page.text_box.txa_text_box}
    @{actual_result}  BuiltIn.Create List
    FOR  ${item}  IN  @{elements}
        ${text}  SeleniumLibrary.Get Text  ${item}
        Collections.Append To List         ${actual_result}  ${text}
    END
    log  ${actual_result}
    BuiltIn.Should Be Equal  ${expect_result}  ${actual_result}

Verify check box success
    [Arguments]  ${expect_result}
    @{elements}       SeleniumLibrary.Get WebElements  ${element_manu_page.check_box.txa_check_box}
    @{actual_result}  BuiltIn.Create List
    FOR  ${item}  IN  @{elements}
        ${text}  SeleniumLibrary.Get Text  ${item}
        Collections.Append To List         ${actual_result}  ${text}
    END
    Log  ${actual_result}
    SeleniumLibrary.Element Text Should Be  ${element_manu_page.check_box.txa_respose}  ${expect_result.verify_massage}
    log  ${expect_result.verify}:${actual_result}
    BuiltIn.Should Be Equal  ${expect_result.verify}  ${actual_result}

Verify radio button
    [Arguments]  ${target_replace}=empty  ${expect_result}=empty  ${replace_string}=***replace***
    IF   '${target_replace}'!='empty'
        ${locator}  String.Replace string  ${element_manu_page.radio_btn.btn_radio_veri}  ${replace_string}  ${target_replace}
        Set Test Variable  ${locator}
    END
    SeleniumLibrary.Wait Until Page Contains  ${${testcase_number}.verify.txt_you_select}
    SeleniumLibrary.Element Should Contain    ${element_manu_page.radio_btn.txt_response_select}  ${expect_result}

Verify registration form
    [Arguments]  ${expect_result}
    Sleep    1sec
#    SeleniumLibrary.Wait Until Page Contains Element  ${element_manu_page.web_tables_menu.registration_form.txt_registration_form}
    SeleniumLibrary.Element Text Should Be            ${element_manu_page.web_tables_menu.registration_form.txt_registration_form}  ${expect_result.header}
    SeleniumLibrary.Element Text Should Be            ${element_manu_page.web_tables_menu.registration_form.lbl_first_name}         ${expect_result.first_name}
    SeleniumLibrary.Element Text Should Be            ${element_manu_page.web_tables_menu.registration_form.lbl_last_name}          ${expect_result.last_name}
    SeleniumLibrary.Element Text Should Be            ${element_manu_page.web_tables_menu.registration_form.lbl_email}              ${expect_result.email}
    SeleniumLibrary.Page Should Contain Button        ${element_manu_page.web_tables_menu.registration_form.btn_submit}

Input registration form
    [Arguments]  ${expect_result}
    Set Test Variable  ${locators}  ${element_manu_page.web_tables_menu.input_registration_form}
    Set Test Variable  ${values}    ${expect_result}
    FOR    ${key}  ${locator}    IN   &{locators}
        ${value}    Get From Dictionary  ${values}  ${key}
        Input Text  ${locator}           ${value}
    END

Verify info on table
    [Arguments]  ${expect_result}  ${replace_string}=***replace***
    Set Test Variable  ${values}    ${expect_result}
    FOR    ${key}  ${value_replace}    IN    &{values}
        IF    '${value_replace}' != 'empty'
            ${locator}  String.Replace string   //div[@class='rt-td'][contains(text(),'***replace***')]  ${replace_string}   ${value_replace}
        END
        SeleniumLibrary.Element Text Should Be  ${locator}  ${value_replace}
    END