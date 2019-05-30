package com.dexcom.springboard;

import org.apache.kafka.clients.producer.Producer;
import org.apache.kafka.clients.producer.ProducerConfig;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.Map;

@Controller
public class KafkaProducer<S, S1> {

    @Value("${kafka_cloud_config.bootstrap.servers:value not available}")
    private String bootstrap_servers;
    @Value("${kafka_cloud_config.sasl.jaas.config:Not available}")
    private String sasl_jaas_config;


    @GetMapping("/kafka/config")
    @ResponseBody
    public Map<String, String> kafkaconfig() {
        HashMap<String, String> map = new HashMap<>();
        map.put("bootstrap.servers",bootstrap_servers);
        return map;
    }

    @Autowired
    private KafkaTemplate<String, String> kafkaTemplate;

    @GetMapping("/kafka/publish")
    @ResponseBody
    public Map<String, String> kafkapublish(@RequestParam(defaultValue = "dexcom.hello") String topicName,@RequestParam(defaultValue = "{\"hello\":\"java\"}") String msg) {


        kafkaTemplate.send(topicName, msg);

        HashMap<String, String> map = new HashMap<>();
        map.put("status","send invoked - hopeful of delivery");
        return map;
    }


}
