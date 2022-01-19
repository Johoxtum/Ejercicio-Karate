Feature: Delete Favorite

Background: precondiciones

    Given url apiUrl

    * def TokenResponse = callonce read('classpath:helpers/createToken.feature')
    * def token = TokenResponse.authToken
    

Scenario: Delete Favorite

    Given path "articles"
    Given params {limit: 10,offset: 0}
    And header Authorization = "Token " + token
    When method Get
    Then status 200
    * print response

    * def id_slug = response.articles[0].slug
    Given path "articles/" + id_slug + "/favorite"
    And header Authorization = "Token " + token
    When method Delete
    Then status 200
    * print response

   