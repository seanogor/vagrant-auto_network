require 'auto_network/action/base'

class AutoNetwork::Action::LoadPool < AutoNetwork::Action::Base
  # Handle the loading and unloading of the auto_network pool
  #
  # @param env [Hash]
  #
  # @option env [AutoNetwork::Pool] auto_network_pool The global auto network pool
  # @option env [Vagrant::Environment] env The Vagrant environment containing
  #   the active machines that need to be filtered.
  #
  # @return [void]
  def call(env)
    @env = env

    if env_ready?
      setup_ivars
      deserialize! if AutoNetwork.pool_manager.nil?
      @app.call(@env)
    else
      @app.call(@env)
    end
  end

  private

  def env_ready?
    !!@env[:env].home_path
  end

  def setup_ivars
    @config_path = @env[:env].home_path.join('auto_network')
    @statefile   = @config_path.join('pool.yaml')
  end

  def deserialize!
    unless @statefile.exist?
      @env[:env].ui.info "Initializing AutoNetwork pool storage."
    end
    AutoNetwork.pool_manager = AutoNetwork::PoolManager.new(@statefile)
  end
end
