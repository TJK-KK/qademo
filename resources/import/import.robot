*** Settings ***
Library  SeleniumLibrary
Library  OperatingSystem
Library  DebugLibrary
Library  SSHLibrary
Library  String
Library  Collections
Library  RequestsLibrary
Resource  ${CURDIR}/../lib/cpwebcommon.robot

Variables  ${CURDIR}/../settings/common_config.yaml
Variables  ${CURDIR}/../locator/common_locator.yaml

#page

#feature
Resource  ${CURDIR}/../../keywords/features/Element_feature.robot

#common
Resource  ${CURDIR}/../../keywords/common/common_keywors.robot