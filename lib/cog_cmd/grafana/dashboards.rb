require 'cog_cmd/grafana'
require 'grafana/command'

module CogCmd::Grafana
  class Dashboards < Grafana::Command
    def run_command
      response.template = 'dashboards'
      response.content = formatted_dashboards
    end

    def dashboards
      client.dashboards
        .map { |d| d["slug"] = d["uri"].gsub(/^db\//, ""); d }
        .sort_by { |d| d["slug"] }
    end

    def formatted_dashboards
      if tag.nil?
        dashboards
      else
        dashboards.select{|db| db["tags"].include? tag.to_s }
      end
    end

    def tag
      request.args[0]
    end
  end
end
