*** Keywords ***
Default test teardown
    [Documentation]    Capture screenshot for every test case
    ...     \n all failed case always logs and returns the HTML source of the current page or frame.
    Run Keyword If Test Failed     SeleniumLibrary.Capture Page Screenshot
    Run Keyword If Test Failed      Run Keyword And Ignore Error    SeleniumLibrary.Log Source
    SeleniumLibrary.Close all browsers

Open chrome browser
    [Documentation]     Open chrome browser with so many option to customize.
                        ...     \n ``browser_mode`` can be either desktop or mobile to open in mobile resolution
                        ...     \n ``headless`` to open browser in headful or headless mode
                        ...     \n ``extension_full_path`` if not empty will install chrome extention from given path
                        ...     \n ``with_download_dir`` create chrome driver with download directory default at ${OUTPUT_DIR}/downloads_${current_time_epoch_format}
                        ...     \n ``with_proxy`` create chrome driver and start local proxy for capturing network
                        ...     \n ``path_to_browsermob_proxy`` path to browsermob installation file
                        ...     \n ``with_save_pdf`` True if want to automatically save PDF from chorme preview printing screen
    [Arguments]     ${url}
                    ...     ${browser_mode}=desktop
                    ...     ${headless}=${FALSE}
                    ...     ${extension_full_path}=${EMPTY}
                    ...     ${with_download_dir}=${FALSE}
                    ...     ${with_proxy}=${FALSE}
                    ...     ${path_to_browsermob_proxy}=${EMPTY}
                    ...     ${with_save_pdf}=${FALSE}
    ${chrome_options}=     Evaluate       sys.modules['selenium.webdriver'].ChromeOptions()     sys, selenium.webdriver
    Call Method     ${chrome_options}     add_argument     --disable-infobars
    Call Method     ${chrome_options}     add_argument     --window-size\=1920,1080
    Call Method     ${chrome_options}     add_argument     --disable-dev-shm-usage
    Call Method     ${chrome_options}     add_argument     --disable-gpu
    Call Method     ${chrome_options}     add_argument     --no-sandbox
    Call Method     ${chrome_options}     add_argument     --ignore-certificate-errors
    IF  '${extension_full_path}' != '${EMPTY}'
            Call Method     ${chrome_options}      add_extension   ${extension_full_path}
    END
    IF  ${headless}
        Call Method     ${chrome_options}      add_argument    --headless
        Call Method     ${chrome_options}      add_argument    --window-size\=1920,1080
    END
    IF  ${with_download_dir}
        ${current_time}=            Builtin.Get time    epoch
        ${download_directory}=      OperatingSystem.Join path    ${OUTPUT_DIR}    downloads_${current_time}
        OperatingSystem.Create directory            ${download_directory}
        Wait until keyword succeeds    5x    2s     OperatingSystem.Directory Should Exist  ${download_directory}
        ${prefs}=                   Builtin.Create dictionary    download.default_directory=${download_directory}
        Log to console      file will be downloaded to ${download_directory}
        Builtin.Call Method    ${chrome_options}    add_experimental_option    prefs    ${prefs}
    ELSE
        ${download_directory}=  Set variable    ${EMPTY}
    END
    IF  ${with_save_pdf}
        ${current_time}=            Builtin.Get time    epoch
        ${download_directory}=      OperatingSystem.Join path    ${OUTPUT_DIR}    downloads_${current_time}
        OperatingSystem.Create directory            ${download_directory}
        Wait until keyword succeeds    5x    2s     OperatingSystem.Directory Should Exist  ${download_directory}
        ${json}=        JSONLibrary.Convert String to JSON    { "appState": { "recentDestinations": [{"id": "Save as PDF","origin": "local","account":""}],"selectedDestinationId": "Save as PDF","version": ${2}}}
        ${prefs}=       Create Dictionary
                        ...     savefile.default_directory=${download_directory}
                        ...     download.default_directory=${download_directory}
                        ...     download.prompt_for_download=${FALSE}
                        ...     directory_upgrade=${TRUE}
                        ...     plugins.plugins_disabled=Chrome PDF Viewer
                        ...     printing.print_preview_sticky_settings=${json}
                        ...     plugins.always_open_pdf_externally=${TRUE}
                        ...     download.extensions_to_open=applications/pdf
        Call Method     ${chrome_options}     add_argument     --kiosk-printing
        Call Method     ${chrome_options}     add_argument     --disable-print-preview
        Call Method     ${chrome_options}     add_experimental_option    prefs    ${prefs}
    END
    IF  '${browser_mode}' == 'mobile'
        ${mobile_emulation}=    Create Dictionary    deviceName=iPhone X
        Call Method    ${chrome_options}    add_experimental_option    mobileEmulation    ${mobile_emulation}
    END
    SeleniumLibrary.Create WebDriver    Chrome      options=${chrome_options}
    SeleniumLibrary.Go To     ${url}
    IF  '${browser_mode}' == 'desktop'
        SeleniumLibrary.Maximize Browser Window
    END
    RETURN    ${download_directory}

Click element when ready
    [Documentation]     Keyword to wait for element to be visible before clicking.
    ...     \n default retry clicking is 3 times
    ...     \n can also wait for only page is CONTAINS element instead of visible
    ...     \n can also replace locator
    [Arguments]     ${locator}  ${target_replace}=empty    ${replace_string}=***replace***        ${retry}=4      ${only_contains}=${FALSE}   ${timeout}=${GLOBAL_TIMEOUT}
    IF   '${target_replace}'!='empty'
        ${locator}    String.Replace string     ${locator}   ${replace_string}   ${target_replace}
    END
    FOR     ${i}    IN RANGE    1   ${retry}
        IF  ${only_contains}
            ${wait_status}=             Run keyword and ignore error   SeleniumLibrary.Wait until page contains element     ${locator}    ${timeout}
            ${err_msg_wait}=            Convert to string       ${wait_status[1]}
            ${is_not_stale_wait}=       Run keyword and return status    Should not contain     ${err_msg_wait}      StaleElementReferenceException
        ELSE
            SeleniumLibrary.Wait until element is enabled    ${locator}     ${timeout}
            ${wait_status}=             Run keyword and ignore error   SeleniumLibrary.Wait until element is visible        ${locator}   ${timeout}
            ${err_msg_wait}=            Convert to string       ${wait_status[1]}
            ${is_not_stale_wait}=       Run keyword and return status    Should not contain     ${err_msg_wait}      StaleElementReferenceException
        END
        ${is_success}=          Run keyword and ignore error   SeleniumLibrary.Click element   ${locator}
        ${err_msg}=             Convert To String       ${is_success[1]}
        ${is_obsecure}=         Run keyword and return status    Should not contain     ${err_msg}       Other element would receive the click
        ${is_not_stale}=        Run keyword and return status    Should not contain     ${err_msg}       StaleElementReferenceException
        ${is_no_err}=           Run keyword and return status    Should be true        '${err_msg}' == '${NONE}'
        ${is_empty_wait}=       Run keyword and return status    Should be true         '${err_msg_wait}' == '${NONE}'
        ${result}=              Evaluate    ${is_success} and ${is_not_stale_wait} and ${is_obsecure} and ${is_not_stale} and ${is_no_err} and ${is_empty_wait}
        Exit for loop if        ${result}
        Log     'retry clicking element for ${i} time with error: ${err_msg}, ${err_msg_wait}'   level=WARN
    END
    Should be true  ${result}   msg="Failed to click element after ${retry} retry"

Input text to element when ready
    [Documentation]     Wait for element to be visible first before input text. Retry 4 times
    [Arguments]     ${locator}     ${text}      ${target_replace}=empty    ${replace_string}=***replace***   ${clear}=${TRUE}     ${timeout}=${GLOBAL_TIMEOUT}
    IF   '${target_replace}'!='empty'
        ${locator}    String.Replace string     ${locator}   ${replace_string}   ${target_replace}
    END
    SeleniumLibrary.Wait until element is visible    ${locator}     ${timeout}
    FOR    ${index}    IN RANGE    1    4
        ${result_msg}=      Run Keyword And Ignore Error    SeleniumLibrary.Input Text      ${locator}     ${text}     clear=${clear}
        ${err_msg}=         Convert To String       ${result_msg[1]}
        ${is_success}=                  Run keyword and return status    Should Be Equal        ${err_msg}      None
        ${is_not_loading_error}=        Run keyword and return status    Should Not Contain     ${err_msg}      invalid element state
        Exit For Loop If        ${is_success} or ${is_not_loading_error}
    END
    Should Be True      ${is_success}   msg=Unable to input text to element after 4 retry

Get Element Count when ready
  [Arguments]     ${locator}
  SeleniumLibrary.Wait until element is visible  ${locator}  ${timeout}
  ${count_job}  Get Element Count                ${locator}
  [Return]  ${count_job}