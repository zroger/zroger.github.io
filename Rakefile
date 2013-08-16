require 'faker'
require 'date'

desc 'Generate sample content for testing.'
task 'generate-test-content' do
    dir = File.join('_posts', 'test')
    mkdir_p dir if !Dir.exists? dir

    date = Date.today
    50.times do
        date = date - rand(1..50)
        words = Faker::Lorem.words
        stub = words.join('-')
        title = words.join(' ').capitalize
        filename = "#{date.strftime('%Y-%m-%d')}-#{stub}.md"

        File.open(File.join(dir, filename), 'w') do |f|
            f.write "---\n"
            f.write "title: #{title}\n"
            f.write "layout: post\n"
            f.write "---\n"
            f.write Faker::Lorem.paragraphs.join("\n\n")
            f.write "\n"
        end
    end
end

desc 'Clean up test content'
task :clean do
    rm_rf "_posts/test"
end
