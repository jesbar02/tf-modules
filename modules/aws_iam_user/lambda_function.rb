# require "net/http"
# require "uri"
# require 'json'
# require 'aws-sdk-ecs'
# ECS = Aws::ECS::Client.new
#
# def get_running_task_arns( cluster_arn, service_name )
#     ECS.list_tasks({
#       cluster: cluster_arn,
#       service_name: service_name,
#       desired_status: "RUNNING"
#     }).task_arns
# end
#
# def describe_running_tasks( cluster_arn, running_task_arns )
#     ECS.describe_tasks({
#       cluster: cluster_arn,
#       tasks: running_task_arns
#     }).tasks
# end
#
# def notify(text)
#     uri = URI.parse(ENV['WEBHOOK_URL'])
#     http = Net::HTTP.new(uri.host, uri.port)
#     http.use_ssl = true
#     request = Net::HTTP::Post.new(uri.request_uri)
#     request.body = { text: text }.to_json
#     http.request(request)
#     puts text
# end
#
# def lambda_handler(event:, context:)
#     service_name = event['detail']['responseElements']['service']['events'][0]['message'].split(' ')[1][0...-1]
#     cluster_arn = event['detail']['responseElements']['service']['clusterArn']
#     return notify("No container running on service #{service_name}") if get_running_task_arns( cluster_arn, service_name ).size == 0
#     task_definition_arn = event['detail']['responseElements']['service']['taskDefinition']
#     while true
#         send_successfull_notification = true
#         running_tasks_arns = get_running_task_arns( cluster_arn, service_name )
#         sleep 2
#         break if running_tasks_arns.size == 0
#         running_tasks_list = describe_running_tasks( cluster_arn, running_tasks_arns )
#         running_tasks_list.each do |task|
#             if task.task_definition_arn != task_definition_arn
#                 send_successfull_notification = false
#                 next
#             end
#         end
#         break if send_successfull_notification
#         return notify("*#{service_name}* hasn't been rolled out within a period of 10 minutes :warning:") if context.get_remaining_time_in_millis <= 60000
#     end
#     task_definition = ECS.describe_task_definition({
#       task_definition: task_definition_arn,
#     }).task_definition
#     build_number = task_definition.container_definitions[0].image.split('-').last
#     common_message = "[CircleCI Build: #{build_number}] *#{service_name}*"
#     text = send_successfull_notification ? "#{common_message} has been deployed successfully. :rocket:" : "#{common_message} deployment has failed. :boom:"
#     notify(text)
#     { statusCode: 200, body: JSON.generate('Lambda finished successfully!') }
# end
