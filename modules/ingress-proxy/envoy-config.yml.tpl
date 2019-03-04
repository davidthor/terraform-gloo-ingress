node:
  cluster: gateway
  id: "{{ "{{" }}.PodName{{ "}}" }}.{{ "{{" }}.PodNamespace{{ "}}" }}"
  metadata:
    # this line must match !
    role: "{{ "{{" }}.PodNamespace{{ "}}" }}~gateway-proxy"
  static_resources:
    clusters:
      - name: xds_cluster
        connect_timeout: 5.000s
        load_assignment:
          cluster_name: xds_cluster
          endpoints:
            - lb_endpoints:
                - endpoint:
                    address:
                      socket_address:
                        address: ${GLOO_SERVICE_NAME}
                        port_value: ${XDS_PORT}
        http2_protocol_options: {}
        type: STRICT_DNS
  dynamic_resources:
    ads_config:
      api_type: GRPC
      grpc_services:
        - envoy_grpc: {cluster_name: xds_cluster}
    cds_config:
      ads: {}
    lds_config:
      ads: {}
  admin:
    access_log_path: /dev/null
    address:
      socket_address:
        address: 127.0.0.1
        port_value: 19000
