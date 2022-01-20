Feature: Delete Favorite

Background: precondiciones

    Given url apiUrl

    * def TokenResponse = callonce read('classpath:helpers/createToken.feature')
    * def token = TokenResponse.authToken
    * def SlugResponse = callonce read('classpath:helpers/getSlug.feature')
    * def slugg = SlugResponse.id_slug
    
Scenario: Delete Favorite

    Given path "articles"
    Given params {limit: 10,offset: 0}
    And header Authorization = "Token " + token
    When method Get
    Then status 200
    * print response

    
    Given path "articles/" + slugg + "/favorite"
    And header Authorization = "Token " + token
    When method Delete
    Then status 200
    

   