%w[config app].each do |folder|
    require_relative "#{folder}/init"
end
