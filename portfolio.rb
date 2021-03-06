# Title: Portfolio Plugin for Jekyll
# Author: Sebastian Ruiz http://sruiz.co.uk, original code by: Wern Ancheta http://anchetawern.github.com
# Description: Octopress portfolio plugin.
#

module Jekyll
  class Portfolio < Liquid::Tag

    def initialize(tag_name, id, tokens)
      super
      @project_folder = id.to_s.strip
    end

    def render(context)

      content = ""
      projects = []

      ignore_list = [".", "..", ".DS_Store", "index.markdown"]

      portfolio_root = context.registers[:site].config['portfolio_root']             # /portfolio
      portfolio_dir_path = context.registers[:site].config['portfolio_path']         # /Volumes/Macintosh HD/Sebastian/Sites/octopress/source/portfolio

      portfolio_dir = Dir.new portfolio_dir_path

      if(@project_folder == "")

        portfolio_dir.each do |project|
          if not ignore_list.include?(project) and File.directory?("#{portfolio_dir_path}/#{project}")
            projects.push(project)
          end
        end

        projects.each do |project_name|
          Dir.foreach(portfolio_dir_path + "/" + project_name) do |screenshot|
            if not ignore_list.include?(screenshot) and File.file?("#{portfolio_dir_path}/#{project_name}/#{screenshot}")

              link = portfolio_root + "/" + project_name
              img = link + "/" + screenshot   #changed.

              title = File.basename(screenshot, File.extname(screenshot))

              if(screenshot.index "main")
                content += '<div class="gallery-item viewport clearfix">'
                content += '<a rel="gallery1" title="' + title + '" href="' + link + '" class="fancybox"><span class="dark-background">'+ project_name + '</span><img src="' + img + '"></a>'
                content += '</div>'
              end
            end
          end
        end
      else

        Dir.foreach(portfolio_dir_path + "/" + @project_folder) do |screenshot|
          if not ignore_list.include?(screenshot) and File.file?("#{portfolio_dir_path}/#{@project_folder}/#{screenshot}")

            link = portfolio_root + "/" + @project_folder
            img = link + "/" + screenshot   #changed.
            title = File.basename(screenshot, File.extname(screenshot))

            real_title = title.sub("small-", "")
            big_img = img.sub("small-", "")

            if(title.index "small-")
              content += '<a title="' + real_title + '" href="' + big_img + '" class="fancybox"><img src="' + img + '"></a>'
            end
            if(title.index "main-")
              content += '<a title="' + real_title + '" href="' + big_img + '" class="fancybox"><img src="' + img + '"></a>' # remove if you don't need main-* image on the portfolio page.
            end
          end
        end
      end
      return content
    end
  end
end

Liquid::Template.register_tag('portfolio', Jekyll::Portfolio)
