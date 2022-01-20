Feature: Get slug

Background: precondiciones
    Given url apiUrl
    * def TokenResponse = callonce read('classpath:helpers/createToken.feature')
    * def token = TokenResponse.authToken

Scenario: Get slug

    Given path "articles"
    Given params {limit: 10,offset: 0}
    And header Authorization = "Token " + token
    When method Get
    Then status 200   
    * def id_slug = response.articles[0].slug
   
    