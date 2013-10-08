ActionController::Routing::Routes.draw do |map|
  # Add your own custom routes here.
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Here's a sample route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  map.connect '', :controller => 'event', :action => 'list'
  
  map.connect ':year/:month/:day', :controller => 'event', :action => 'by_date',
    :requirements => { :year => /\d{4}/, :month => /\d{1,2}/, :day => /\d{1,2}/ }
    
  map.connect ':controller/:action/:year/:month/:day', :requirements => 
    { :year => /\d{4}/, :month => /\d{1,2}/, :day => /\d{1,2}/ }
    
  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  map.connect 'ical', :controller => 'ical', :action => 'index' 
  
  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id'
end
