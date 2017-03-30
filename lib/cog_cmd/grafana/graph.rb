require 'cog_cmd/grafana'
require 'grafana/command'
require 'active_support/all'

module CogCmd::Grafana
  class Graph < Grafana::Command
    def run_command
      panel = client.panels(dashboard_slug)
                    .find { |p| p["title"].parameterize == panel_slug }

      graph = client.graph(dashboard_slug, panel["id"], hours.to_i, server)

      response.template = 'graph'
      response.content = { graph_img: graph, dash_url: "#{ENV['GRAFANA_URL']}/dashboard/db/#{dashboard_slug}", panel_url: "#{ENV['GRAFANA_URL']}/dashboard/db/#{dashboard_slug}/?panelId=#{panel["id"]}&fullscreen&orgId=1" }
    end

    private

    def dashboard_slug
      request.args[0]
    end

    def panel_slug
      request.args[1]
    end

    def hours
      request.args[2]
    end

    def server
      request.args[3]
    end
  end
end
