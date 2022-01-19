package helpers;

import com.github.javafaker.Faker;

import net.minidev.json.JSONObject;

public class DataGenerate {

    public static JSONObject getRamdomArticleValues() {

        Faker faker = new Faker();
        String descripcion = faker.gameOfThrones().city();
        JSONObject json = new JSONObject();
        json.put("description", descripcion);
        return json;
    }

    public static String getRamdomEmail(){
        Faker faker = new Faker();
        String email = faker.name().firstName().toLowerCase() + faker.random().nextInt(0,100) + "@test.com";        
        return email;
    }
    public static String getRamdomUsername(){
        Faker faker = new Faker();
        String username = faker.name().username();        
        return username;
    }
}
