# encoding: utf-8
#
# Based on https://github.com/mwotton/lambdamechanic-jekyll and modified to suit
#   a different site architecture
#
# If you want to print pagination links, simply add the following in your
#   category_index.html template:
#
#
# {% if paginator.total_pages > 1 %}
# <nav class="pagination">
#   {% if paginator.previous_page_path %}
#     <a class="button previous" href="{{ paginator.previous_page_path }}" title="Previous posts">previous </a>
#   {% endif %}

#   {% if paginator.next_page_path %}
#     <a class="button next" href="{{ paginator.next_page_path }}" title="Next posts"> next</a>
#   {% endif %}
# </nav>
# {% endif %}

module Jekyll

  class CategoryPagination < Generator
    safe true

    def generate(site)
      if CategoryPager.pagination_enabled?(site)
        site.categories.each do |category, posts|
          paginate(site, category, posts)
        end
      end
    end

    # Paginates each category's posts. Renders the index.html file into paginated
    # directories, ie: page2/index.html, page3/index.html, etc and adds more
    # site-wide data.
    #
    #  +site+         is the Jekyll Site instance.
    #  +category+     is the category currently being processed.
    #  +posts+        is an array of that category's posts
    #
    # {"paginator" => { "page" => <Number>,
    #                   "per_page" => <Number>,
    #                   "posts" => [<Post>],
    #                   "total_posts" => <Number>,
    #                   "total_pages" => <Number>,
    #                   "previous_page" => <Number>,
    #                   "previous_page_path" => <Url>,
    #                   "next_page" => <Number>,
    #                   "next_page_path" => <Url> }}
    def paginate(site, category, posts)

      all_posts = posts.sort_by { |p| p.date }
      all_posts.reverse!

      pages = CategoryPager.calculate_pages(all_posts, site.config['paginate_categories'].to_i)

      (1..pages).each do |num_page|
        pager = CategoryPager.new(site, num_page, all_posts, category, pages)

        page = CategoryPage.new(site, site.source, "_layouts", category)
        page.dir = CategoryPager.paginate_path(site, num_page, category)
        page.pager = pager

        site.pages << page
      end
    end
  end

  class CategoryPage < Page

    # Initializes a new CategoryPage.
    #
    #  +site+         is the Jekyll Site instance.
    #  +base+         is the String path to the <source>.
    #  +category_dir+ is the String path between <source> and the category folder.
    #  +category+     is the category currently being processed.
    def initialize(site, base, category_dir, category)
      @site = site
      @base = base
      @dir  = category_dir
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'category_index.html')

      self.data['title']       = "#{category}"
    end
  end

  class CategoryPager
    attr_reader :page, :per_page, :posts, :total_posts, :total_pages,
      :previous_page, :previous_page_path, :next_page_path, :next_page, :category

    def self.calculate_pages(all_posts, per_page)
      (all_posts.size.to_f / per_page.to_i).ceil
    end

    # Determine if category pagination is enabled the site.
    #
    # site - the Jekyll::Site object
    #
    # Returns true if pagination is enabled and if there are
    #   cateories, false otherwise.
    def self.pagination_enabled?(site)
      !site.config['paginate_categories'].nil? &&
       site.categories.size > 0
    end

    # Static: Return the pagination path of the page
    #
    # site     - the Jekyll::Site object
    # num_page - the pagination page number
    # category - the category currently being processed.
    #
    # Returns the pagination path as a string
    def self.paginate_path(site, num_page, category)
      return nil if num_page.nil?

      format = site.config['category_path'].sub(':cat', category)

      if num_page > 1
        format = File.join(format, site.config['category_page_path'])
        format = format.sub(':num', num_page.to_s)
      end

      ensure_leading_slash(format)
    end

    # Static: Return a String version of the input which has a leading slash.
    #         If the input already has a forward slash in position zero, it will be
    #         returned unchanged.
    #
    # path - a String path
    #
    # Returns the path with a leading slash
    def self.ensure_leading_slash(path)
      path[0..0] == "/" ? path : "/#{path}"
    end

    def initialize(site, page, all_posts, category, num_pages = nil)

      @category = category
      @page = page
      @per_page = site.config['paginate_categories'].to_i
      @total_pages = num_pages || Pager.calculate_pages(all_posts, @per_page)

      if @page > @total_pages
        raise RuntimeError, "page number can't be greater than total pages: #{@page} > #{@total_pages}"
      end

      init = (@page - 1) * @per_page
      offset = (init + @per_page - 1) >= all_posts.size ? all_posts.size : (init + @per_page - 1)

      @total_posts = all_posts.size
      @posts = all_posts[init..offset]
      @previous_page = @page != 1 ? @page - 1 : nil
      @previous_page_path = CategoryPager.paginate_path(site, @previous_page, category)
      @next_page = @page != @total_pages ? @page + 1 : nil
      @next_page_path = CategoryPager.paginate_path(site, @next_page, category)
    end

    def to_liquid
      {
        'page' => page,
        'per_page' => per_page,
        'posts' => posts,
        'total_posts' => total_posts,
        'total_pages' => total_pages,
        'previous_page' => previous_page,
        'previous_page_path' => previous_page_path,
        'next_page' => next_page,
        'next_page_path' => next_page_path,
        'category' => category
      }
    end
  end
end