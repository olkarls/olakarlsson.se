require ::File.dirname(__FILE__) + '/config/boot.rb'

require 'coderay'
require 'rack/codehighlighter'

use Rack::Codehighlighter, :pygments_api, :markdown => true, :element => "pre>code", :pattern => /\A:::(\w+)\s*(\n|&#x000A;)/i, :logging => false

run Padrino.application