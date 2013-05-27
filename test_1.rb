require 'digest'
require 'securerandom'

# source
# module XYZService
#  def self.xyz_filename(target)
#    # File format:
#    # [day of month zero-padded][three-letter prefix] \
#    # _[kind]_[age_if_kind_personal]_[target.id] \
#    # _[8 random chars]_[10 first chars of title].jpg
#    filename = "#{target.publish_on.strftime("%d")}"
#    filename << "#{target.xyz_category_prefix}"
#    filename << "#{target.kind.gsub("_", "")}"
#    filename << "_%03d" % (target.age || 0) if target.personal?
#    filename << "_#{target.id.to_s}"
#    filename << "_#{Digest::SHA1.hexdigest(rand(10000).to_s)[0,8]}"
#    truncated_title = target.title.gsub(/[^\[a-z\]]/i, '').downcase
#    truncate_to = truncated_title.length > 9 ? 9 : truncated_title.length
#    filename << "_#{truncated_title[0..(truncate_to)]}"
#    filename << ".jpg"
#    return filename
#  end
# end


# result
module XYZService
 def self.xyz_filename(target)
   # File format:
   # [day of month zero-padded][three-letter prefix] \
   # _[kind]_[age_if_kind_personal]_[target.id] \
   # _[8 random chars]_[10 first chars of title].jpg

   # strftime возвращает строку - нет необходимости использовать интерполяцию
   filename = target.publish_on.strftime("%d")
   # если быть уверенным, что xyz_category_prefix возвращает строку, то можно убрать интерполяцию
   filename << "#{target.xyz_category_prefix}"
   # пропущен знак подчеркивания
   filename << "_#{target.kind.gsub("_", "")}"
   filename << "_%03d" % (target.age || 0) if target.personal?
   # при интерполяции to_s вызывается автоматически
   filename << "_#{target.id}"
   # нашел такое решение - скорость выполнения примерно та же, но кода меньше
   # (для использования надо сделать require 'securerandom')
   filename << "_#{SecureRandom.hex(4)}"
   # при интерполяции можно использовать произвольные выражения - незачем выделять переменную для хранения
   # промежуточного результата. Кроме того, при использовании метода [] со строками, если в строке символов
   # меньше, чем длина подстроки, которую необходимо выбрать, то просто возвращаются доступные символы
   # начиная со стартового индекса. Опять же в правиле [10 first chars of title] ничего не сказано о
   # какой-либо дополнительной подготовке названия, но gsub и donwncase не убираю потому что вполне разумное
   # действие. Также думаю, что для присоединения '.jpg' можно обойтись и без дополнительного вызова <<
   # и еще - в литерале диапазона 0..(truncate_to) можно было обойтись и без скобок вокруг переменной.
   filename << "_#{target.title.gsub(/[^\[a-z\]]/i, '').downcase[0,10]}.jpg"
   # return не нужен - возвращаемым значением метода становится результат последнего выражения. В данном 
   # случае метод << возвращает результат объединения исходной строки и строки переданной в качестве параметра
 end
end


def bench(n)
   puts Time.now
   n.times { yield }
   puts Time.now
end

bench(1000000) { SecureRandom.hex(4) }
bench(1000000) { Digest::SHA1.hexdigest(rand(10000).to_s)[0,8] }




module Attributable
   def my_attr_reader(*attrs)
      attrs.each do |attr|
         define_method(attr) { instance_variable_get(:"@#{attr}") }
      end
   end

   def my_attr_accessor(*attrs)
      attrs.each do |attr|
         my_attr_reader(attr)
         define_method(:"#{attr}=") {|value| instance_variable_set(:"@#{attr}", value) }
      end
   end
end

class MyClass
   extend Attributable
   
   my_attr_accessor :test
end

mc = MyClass.new
mc.test = 5
p mc.test