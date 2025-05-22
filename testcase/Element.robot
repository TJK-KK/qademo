*** Settings ***
Resource    ${CURDIR}/../resources/import/import.robot
Variables   ${CURDIR}/../resources/testdata/Element.yaml
Test Teardown  Default test teardown

*** Test Cases ***
TC_001 Success - Verify element page
    [Tags]  TC_001
    common_keywors.Set test data number           TC_001
    Element_feature.Open element page
    cpwebcommon.Click element when ready          ${element_manu_page.text_box.btn_text_box}
    cpwebcommon.Input text to element when ready  ${element_manu_page.text_box.txt_full_name}         ${${testcase_number}.input.full_name}
    cpwebcommon.Input text to element when ready  ${element_manu_page.text_box.txt_email}             ${${testcase_number}.input.email}
    cpwebcommon.Input text to element when ready  ${element_manu_page.text_box.txt_currentAddress}    ${${testcase_number}.input.current_address}
    cpwebcommon.Input text to element when ready  ${element_manu_page.text_box.txt_permanentAddress}  ${${testcase_number}.input.permanent_address}
    SeleniumLibrary.Scroll Element Into View      ${element_manu_page.text_box.btn_bsa}
    cpwebcommon.Click element when ready          ${element_manu_page.text_box.btn_submit}
    Element_feature.Verify text box success       ${${testcase_number}.verify}

TC_002 Success - Verify check box
    [Tags]  TC_002
    common_keywors.Set test data number       TC_002
    Element_feature.Open element page
    cpwebcommon.Click element when ready      ${element_manu_page.check_box.btn_check_box}
    cpwebcommon.Click element when ready      ${element_manu_page.check_box.chb_home}
    Element_feature.Verify check box success  ${${testcase_number}}

TC_003 Success - Verify 'Yes' button
    [Tags]  TC_003
    common_keywors.Set test data number       TC_003
    Element_feature.Open element page
    cpwebcommon.Click element when ready      ${element_manu_page.radio_btn.btn_radio_menu}
    SeleniumLibrary.Element Text Should Be    ${element_manu_page.radio_btn.txn_question}           ${${testcase_number}.question}
    cpwebcommon.Click element when ready      ${element_manu_page.radio_btn.btn_radio_yes}
    Element_feature.Verify radio button       ${${testcase_number}.verify.response_select}

TC_004 Success - Verify 'Impressive' button
    [Tags]  TC_004
    common_keywors.Set test data number       TC_004
    Element_feature.Open element page
    cpwebcommon.Click element when ready      ${element_manu_page.radio_btn.btn_radio_menu}
    SeleniumLibrary.Element Text Should Be    ${element_manu_page.radio_btn.txn_question}          ${${testcase_number}.question}
    cpwebcommon.Click element when ready      ${element_manu_page.radio_btn.btn_radio_impressive}
    Element_feature.Verify radio button       ${${testcase_number}.btn_radio}                      ${${testcase_number}.verify.response_select}

TC_005 Success - Verify add test
    [Tags]  TC_005
    common_keywors.Set test data number       TC_005
    Element_feature.Open element page
    cpwebcommon.Click element when ready      ${element_manu_page.web_tables_menu.btn_web_tables_menu}
    cpwebcommon.Click element when ready      ${element_manu_page.web_tables_menu.btn_add}
    Element_feature.Verify registration form  ${${testcase_number}.registration_form}
    Element_feature.Input registration form   ${${testcase_number}.input_registration_form}
    cpwebcommon.Click element when ready      ${element_manu_page.web_tables_menu.registration_form.btn_submit}
    Element_feature.Verify info on table      ${${testcase_number}.input_registration_form}

TC_006 Success - Go to new link
    [Tags]  TC_006
    Element_feature.Open element page
    cpwebcommon.Click element when ready      ${element_manu_page.links_page.links_page_menu}
    cpwebcommon.Click element when ready      ${element_manu_page.links_page.lnk_simpleLink}
    SeleniumLibrary.Page Should Contain Image  ${main_page.image_toolsqa}
