Presto.controllers :pages do
  before do
    @menu_items = Page.menu_items
    @title = Nesta::Config.title
    @subtitle = Nesta::Config.subtitle
    @keywords = Nesta::Config.keywords
    @description = Nesta::Config.description
    @author = Nesta::Config.author
    @google_analytics_code = Nesta::Config.google_analytics_code
    @heading = @title
  end

  get :index, :map => '/' do

    @title = "#{@title} - #{@subtitle}"
    @articles = Page.find_articles[0..7]
    @body_class = "home"
    render "themes/#{Nesta::Config.theme}/index", :layout => "themes/#{Nesta::Config.theme}/application".to_sym
  end
  
  get :feed, :map => '/feed' do
    content_type :xml, :charset => "utf-8"
    @articles = Page.find_articles.select { |a| a.date }[0..9]
    render "themes/#{Nesta::Config.theme}/atom"
  end
  
  get :sitemap, :map => "/sitemap.xml" do
    content_type :xml, :charset => "utf-8"
    @pages = Page.find_all.select{|p| p.metadata.sitemap or p.metadata.sitemap.blank?}
    @last = @pages.map { |page| page.last_modified }.inject do |latest, page|
      (page > latest) ? page : latest
    end
    render "themes/#{Nesta::Config.theme}/sitemap"
  end
  
  get :attachments, :map => '/attachments/{:filename,(\w|\-|\.)}' do
    file = File.join(
        Nesta::Config.attachment_path, params[:filename])
    send_file(file, :disposition => nil)
  end
  
  get :catchall, :map => '*splat' do
    @page = Page.find_by_path(File.join(params[:splat]))
    raise Sinatra::NotFound if @page.nil?
    @title = @page.title
    @description = @page.description
    @keywords = @page.keywords
    render "themes/#{Nesta::Config.theme}/#{@page.template}", :layout => @page.layout
  end
end