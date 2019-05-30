package com.dexcom.springboard;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.Map;

@Controller
public class KafkaProducer {

    @Value("${kafka_cloud_config.bootstrap.servers:value not available}")
    private String bootstrap_servers;
    @Value("${kafka_cloud_config.sasl.jaas.config:Not available}")
    private String sasl_jaas_config;



    @GetMapping("/kafka-config")
    @ResponseBody
    public Map<String, String> kafkaconfig() {
        HashMap<String, String> map = new HashMap<>();
        map.put("bootstrap.servers",bootstrap_servers);
        map.put("sasl.jaas.config",sasl_jaas_config);
        return map;
    }

}
