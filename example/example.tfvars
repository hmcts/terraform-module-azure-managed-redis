#example environment.tfvars 

redis_access_policy_assignments = {
    "Data Owner" = {
        # groups are currently not supported by Azure
        create-default-mi  = {}                                                          # new MI, named: myapp-cache-sandbox-api-service-mi
        custom-name-mi     = { display_name = "my-redis-example-mi" }                          # new MI, custom name
        add-existing-users = { object_id = "e132cb6e-b6eb-4aa6-b641-b4d7ed03a422" }     # pre-existing user, no MI created
    }
}