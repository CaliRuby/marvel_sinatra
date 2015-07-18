require 'sinatra'
require 'sinatra/namespace'
require 'redis'
require 'active_support'
require_relative 'models/metrics'
require_relative 'models/data_structures'
require_relative 'models/user'

module Jsonify
  refine Object do
    def to_json
      ActiveSupport::JSON.encode(self)
    end

    def from_json
      ActiveSupport::JSON.decode(self)
    end
  end
end

using Jsonify

namespace '/users' do
  post '' do
    attrs = request.body.read.from_json
    User.create(attrs['name'])
    201
  end

  get '' do
    User.all.to_json
  end

  get '/top5' do
    fn_user = lambda{ |name|  User.find(name) }
    top5 = metrics.top_five_login.map(&fn_user).reject {|e| e.nil? }
    top5.to_json
  end

  get '/online' do
    fn_user = ->(name){ User.find(name) }
    online = metrics.users_online.map(&fn_user).reject {|e| e.nil? }
    online.to_json
  end

  put '/login/:id' do
    response = if !params[:id].nil? && !User.find(params[:id]).nil?
      metrics.login_count_for(params[:id])
      metrics.track_online(params[:id])
      201
    else
      400
    end

    status response
  end

  delete '/:id' do
    User.delete(params[:id])
    200
  end
end

def metrics
  @metrics ||= Metrics.new
end

