require 'mechanize'

module UserStyles
  class Client
    def initialize(options={})
      @agent = Mechanize.new
      login = @agent.get(BASE_URL + 'login')
      form = login.form(:id => 'password-login')
      form.login    = options[:username]
      form.password = options[:password]
      @agent.submit(form)
    end

    def list_styles
      table = @agent.get(BASE_URL + 'login').search(".//table[@class='author-styles']")
      styles = []
      table.xpath('//tbody/tr').each do |tr|
        links = tr.xpath('.//a')
        styles << {
          :name   => links[0].content,
          :show   => links[0].attr('href'),
          :edit   => links[1].attr('href'),
          :delete => links[2].attr('href'),
        }
      end
      styles
    end

    def get_style(name)
      styles = list_styles
      styles.each do |style|
        return style if style[:name].match(/#{name}/i)
      end
      nil
    end

    def add_style(options={})
      form = @agent.get(BASE_URL + 'styles/new').form
      form.field_with(:name => 'style[short_description]').value = options[:name]
      form.field_with(:name => 'style[long_description]').value = options[:name]
      form.field_with(:name => 'style[css]').value = options[:css]
      @agent.submit(form)
    end

    def update_style(options)
      form = @agent.get(options[:url]).form
      form.field_with(:name => 'style[short_description]').value = options[:name]
      form.field_with(:name => 'style[long_description]').value = options[:name]
      form.field_with(:name => 'style[css]').value = options[:css]
      @agent.submit(form)
    end
  end
end
