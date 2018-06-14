# rspec spec/utf8_sanitizer/utf_spec.rb
require "spec_helper"

describe "UTF" do
  let(:utf_obj) { Utf8Sanitizer::UTF.new }
  let(:headers) { ["row_id", "url", "act_name", "street", "city", "state", "zip", "phone"] }
  let(:valid_rows) { [{ :row_id=>"1", :url=>"stanleykaufman.com", :act_name=>"Stanley Chevrolet Kaufman", :street=>"825 E Fair St", :city=>"Kaufman", :state=>"TX", :zip=>"75142", :phone=>"(888) 457-4391" }] }

  let(:orig_hashes) { [{ :row_id=>"1", :url=>"stanleykaufman.com", :act_name=>"Stanley Chevrolet Kaufman\x99_\xCC", :street=>"825 E Fair St", :city=>"Kaufman", :state=>"TX", :zip=>"75142", :phone=>"(888) 457-4391\r\n" }] }

  let(:utf_result) { {:stats=>
    {:total_rows=>1, :header_row=>1, :valid_rows=>1, :error_rows=>0, :defective_rows=>0, :perfect_rows=>0, :encoded_rows=>1, :wchar_rows=>1},
   :data=>
    {:valid_data=>
      [{:row_id=>"1",
        :utf_status=>"encoded, wchar",
        :url=>"stanleykaufman.com",
        :act_name=>"Stanley Chevrolet Kaufman",
        :street=>"825 E Fair St",
        :city=>"Kaufman",
        :state=>"TX",
        :zip=>"75142",
        :phone=>"(888) 457-4391"}],
     :encoded_data=>
      [{:row_id=>1, :text=>"1,stanleykaufman.com,Stanley Chevrolet Kaufman\x99_\xCC,825 E Fair St,Kaufman,TX,75142,(888) 457-4391\r\n"}],
     :defective_data=>[],
     :error_data=>[] }}
  }

  before { utf_obj.headers = headers }

  context '#line_parse' do
    let(:first_validated_line) { "row_id,url,act_name,street,city,state,zip,phone" }
    let(:second_validated_line) { "1,stanleykaufman.com,Stanley Chevrolet Kaufman,825 E Fair St,Kaufman,TX,75142,(888) 457-4391" }

    it 'row to headers' do
      utf_obj.line_parse(first_validated_line)
      expect(utf_obj.headers).to eql(headers)
    end

    it "row to data_hash" do
      expect(utf_obj.line_parse(second_validated_line)).to eql(valid_rows)
    end
  end

  context '#process_hash_row' do
    let(:hsh) { {:row_id=>1, :url=>"stanleykaufman.com", :act_name=>"Stanley Chevrolet Kaufman", :street=>"825 E Fair St", :city=>"Kaufman", :state=>"TX", :zip=>"75142", :phone=>"(888) 457-4391"} }
    result = '...'

    it "..." do
      ### Not Complete.  Revisit later.
      # binding.pry
      expect(utf_obj.process_hash_row(hsh)).to eql(result)
    end
  end


  context '#row_to_hsh' do
    let(:row) {["1", "stanleykaufman.com", "Stanley Chevrolet Kaufman", "825 E Fair St", "Kaufman", "TX", "75142", "(888) 457-4391"]}
    result = {:row_id=>"1", :url=>"stanleykaufman.com", :act_name=>"Stanley Chevrolet Kaufman", :street=>"825 E Fair St", :city=>"Kaufman", :state=>"TX", :zip=>"75142", :phone=>"(888) 457-4391"}

    it "converts row to hash" do
      expect(utf_obj.row_to_hsh(row)).to eql(result)
    end
  end


  context '#make_groups_from_array' do
    let(:array) { ["encoded", "wchar", "encoded", "wchar", "encoded", "wchar", "encoded", "wchar", "encoded", "wchar"] }
    result = {"encoded"=>5, "wchar"=>5}

    it "makes groups from array" do
      expect(utf_obj.make_groups_from_array(array)).to eql(result)
    end
  end


  context '#check_utf' do
    let(:text) { "1,stanleykaufman.com,Stanley Chevrolet Kaufman\xDD_h∑,825 E Fair St,Kaufman,TX,75142,(888) 457-4391\r\n" }
    result = {:text=>"1,stanleykaufman.com,Stanley Chevrolet Kaufman\xDD_h∑,825 E Fair St,Kaufman,TX,75142,(888) 457-4391\r\n",
               :encoded=>"1,stanleykaufman.com,Stanley Chevrolet Kaufmanh,825 E Fair St,Kaufman,TX,75142,(888) 457-4391\r\n",
               :wchar=>"1,stanleykaufman.com,Stanley Chevrolet Kaufmanh,825 E Fair St,Kaufman,TX,75142,(888) 457-4391",
               :error=>nil
             }

    it "converts non-utf8 and removes extra whitespace" do
      expect(utf_obj.check_utf(text)).to eql(result)
    end
  end


  context '#utf_filter' do
    let(:utf) {{:text=>"1,stanleykaufman.com,Stanley Chevrolet Kaufman\xE5_\x99,825 E Fair St,Kaufman,TX,75142,(888) 457-4391\r\n",
               :encoded=>"1,stanleykaufman.com,Stanley Chevrolet Kaufman,825 E Fair St,Kaufman,TX,75142,(888) 457-4391\r\n",
               :wchar=>"1,stanleykaufman.com,Stanley Chevrolet Kaufman,825 E Fair St,Kaufman,TX,75142,(888) 457-4391",
               :error=>nil }}

    ### How to test for these? ###
    # @encoded_rows = [{:row_id=>1, :text=>"1,stanleykaufman.com,Stanley Chevrolet Kaufman\xE5_\x99,825 E Fair St,Kaufman,TX,75142,(888) 457-4391\r\n"}]
    # @error_rows = []
    # @defective_rows = []
    # @data_hash = {:row_id=>1, :utf_status=>"encoded, wchar"}
    ##################################
    line = "1,stanleykaufman.com,Stanley Chevrolet Kaufman,825 E Fair St,Kaufman,TX,75142,(888) 457-4391"

    it "gets line from utf_hash" do
      expect(utf_obj.utf_filter(utf)).to eql(line)
    end
  end

  context '#validate_data' do
    let(:args) { {:data=> [{:row_id=>1, :url=>"stanleykaufman.com", :act_name=>"Stanley Chevrolet Kaufman\x99_\xCC", :street=>"825 E Fair St", :city=>"Kaufman", :state=>"TX", :zip=>"75142", :phone=>"(888) 457-4391\r\n"}]} }
    let(:headers) { [] }
    before { utf_obj.headers = headers }

    it "UTF start & end: input as array of hashes or file_path, returns utf_result" do
      expect(utf_obj.validate_data(args)).to eql(utf_result)
    end
  end

  context '#compile_results' do
    valid_rows = [{:row_id=>"1", :utf_status=>"encoded, wchar", :url=>"stanleykaufman.com", :act_name=>"Stanley Chevrolet Kaufman", :street=>"825 E Fair St", :city=>"Kaufman", :state=>"TX", :zip=>"75142", :phone=>"(888) 457-4391"}]
    encoded_rows = [{:row_id=>1, :text=>"1,stanleykaufman.com,Stanley Chevrolet Kaufman\x99_\xCC,825 E Fair St,Kaufman,TX,75142,(888) 457-4391\r\n"}]
    row_id = 1
    before { utf_obj.row_id = row_id }
    before { utf_obj.valid_rows = valid_rows }
    before { utf_obj.encoded_rows = encoded_rows }

    it 'Tallies instance vars and returns final utf_result' do
      expect(utf_obj.compile_results).to eql(utf_result)
    end
  end


  context '#validate_csv' do
    let(:file_path) { './lib/utf8_sanitizer/csv/seeds_dirty_1.csv' }
    headers = []
    before { utf_obj.headers = headers }

    let(:utf_results) { {:stats=>
                          {:total_rows=>2, :header_row=>1, :valid_rows=>1, :error_rows=>0, :defective_rows=>0, :perfect_rows=>0, :encoded_rows=>1, :wchar_rows=>0},
                       :data=>
                        {:valid_data=>
                          [{:row_id=>1,
                            :utf_status=>"encoded",
                            :url=>"http://www.courtesyfordsales.com",
                            :act_name=>"Courtesy Ford",
                            :street=>"1410 West Pine Street Hattiesburg",
                            :city=>"Wexford",
                            :state=>"MS",
                            :zip=>"39401",
                            :phone=>"512-555-1212"}],
                         :encoded_data=>
                          [{:row_id=>1,
                            :text=>
                             "http://www.courtesyfordsales.com,Courtesy Ford,__\xD5\xCB\xEB\x8F\xEB__\xD5\xCB\xEB\x8F\xEB____1410 West Pine Street Hattiesburg,Wexford,MS,39401,512-555-1212"}],
                         :defective_data=>[],
                         :error_data=>[]}}
                    }

    it "takes csv file_path and returns utf_results" do
      expect(utf_obj.validate_csv(file_path)).to eql(utf_results)
    end

  end



  context '#validate_hashes' do
    headers = []
    before { utf_obj.headers = headers }
    let(:results) { {:stats=> { :total_rows=>"1",
                                :header_row=>1,
                                :valid_rows=>1,
                                :error_rows=>0,
                                :defective_rows=>0,
                                :perfect_rows=>0,
                                :encoded_rows=>1,
                                :wchar_rows=>1},
                     :data=> {:valid_data=> [{:row_id=>"1",
                                              :utf_status=>"encoded, wchar",
                                              :url=>"stanleykaufman.com",
                                              :act_name=>"Stanley Chevrolet Kaufman",
                                              :street=>"825 E Fair St",
                                              :city=>"Kaufman",
                                              :state=>"TX",
                                              :zip=>"75142",
                                              :phone=>"(888) 457-4391"}],
                               :encoded_data=>
                                [{:row_id=>"1", :text=>"1,stanleykaufman.com,Stanley Chevrolet Kaufman\x99_\xCC,825 E Fair St,Kaufman,TX,75142,(888) 457-4391\r\n"}],
                               :defective_data=>[],
                               :error_data=>[]}}
                  }

    it 'takes data hashes and returns utf_results' do
      expect(utf_obj.validate_hashes(orig_hashes)).to eql(results)
    end
  end

end



  # context '#validate_hashes' do
  #   let(:orig_hashes) { Utf8Sanitizer::Seed.new.grab_seed_hashes }
  #
  #   it "validates hashes" do
  #     expect(utf_obj.validate_hashes(orig_hashes)).to eql(ExpectedResults.result_for_validate_hashes)
  #   end
  # end

  # context '#utf_sample' do
  #   it "returns 'yes'" do
  #     expect(utf_obj.utf_sample).to eql('yes')
  #   end
  # end

  # describe "sample" do
  # before do
  #   @utf = Utf8Sanitizer::UTF.new
  #   # @csv_path = Dir.pwd + "/spec/csvs/"
  # end
  #
  # it "utf_sample" do
  #  @utf.utf_sample.to eq('yes')
  #  expect(@utf.utf_sample).to eq('yes')
  #
  #   # headers = ["type", "name", "color", "price"]
  #   # @utf.parse(@csv_path + "custom_headers.csv", headers)
  #   # expect(@utf.count).to eq 4
  #   # expect(@utf.cols).to eq headers
  # end
