#example environment.tfvars 
# you have to add each user individually,
# groups are currently not supported by Azure
redis_access_policy_assignments = {
    "Data Owner" = {
        # give each entry a meaningful label
        default01  = {}                                                               # new MI, named: <redis-name>-data-owner-default01-mi
        custom-name-mi     = { display_name = "mi-prd-ccm01-customname" }             # new MI, custom name
        platops-user       = { object_id = "e132cb6e-b6eb-4aa6-b641-b4d7ed03a469" }   # pre-existing user, no MI created
    }
}
