package com.dexcom.springboard;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

@Controller
public class HelloController {

    @RequestMapping(value = "/hello", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Map getString(@RequestParam(name="name",
            required=false,
            defaultValue="World") String name) {
        return Collections.singletonMap("response", "Hello " +name);
    }
    @GetMapping("/")
    public String one() {
        return "redirect:/static/index.html";
    }

    @Value("${kafka_cloud_config.bootstrap.servers:value not available}")
    private String bootstrapServers;


    @GetMapping("/kafka-config")
    @ResponseBody
    public Map<String, String> kafkaconfig() {
        HashMap<String, String> map = new HashMap<>();
        map.put("kafka_cloud_config.bootstrap.servers",bootstrapServers);
        return map;
    }
}


