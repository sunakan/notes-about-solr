class SolrApi::V1Controller < ApplicationController
  def select
    render json: {a: "ok"}
  end
end
