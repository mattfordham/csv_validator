require 'spec_helper'

module Helpers
  def upload(file)
    csv_file = File.open(File.join(File.dirname(__FILE__), file))
    return ActionDispatch::Http::UploadedFile.new(:tempfile => csv_file, :filename => File.basename(csv_file))
  end
end


describe CsvValidator do

  include Helpers
  
  describe "general validation" do
    
    class TestUser1 < TestModel
      validates :csv, :csv => true
    end
    
    it "should be valid" do
      TestUser1.new(:csv => upload('support/3x6.csv')).should be_valid
    end

    it "should be invalid due to maformed CSV" do
      testUser = TestUser1.new(:csv => upload('support/not_csv.png'))
      testUser.should have(1).error_on(:csv)
      testUser.error_on(:csv)[0].should eq("is not a valid CSV file")
    end

  end
  
  describe "column count validation" do
    
    class TestUser2 < TestModel
      validates :csv, :csv => {:columns => 3}
    end

    class TestUser3 < TestModel
      validates :csv, :csv => {:max_columns => 2}
    end

    class TestUser4 < TestModel
      validates :csv, :csv => {:min_columns => 15}
    end

    class TestUser5 < TestModel
      validates :csv, :csv => {:min_columns => 2}
    end
        
    it "should be invalid due to exact column count" do
      testUser = TestUser2.new(:csv => upload('support/2x6.csv'))
      testUser.should have(1).error_on(:csv)
      testUser.error_on(:csv)[0].should eq("should have 3 columns")
    end

    it "should be valid with exact column count" do
      TestUser2.new(:csv => upload('support/3x6.csv')).should be_valid
    end
    
    it "should be invalid due to max column count" do
      testUser = TestUser3.new(:csv => upload('support/3x6.csv'))
      testUser.should have(1).error_on(:csv)
      testUser.error_on(:csv)[0].should eq("should have no more than 2 columns")      
    end

    it "should be valid with max column count" do
      TestUser3.new(:csv => upload('support/2x6.csv')).should be_valid
    end

    it "should be invalid due to min column count" do
      testUser = TestUser4.new(:csv => upload('support/3x6.csv'))
      testUser.should have(1).error_on(:csv)
      testUser.error_on(:csv)[0].should eq("should have at least 15 columns")
    end

    it "should be valid with min column count" do
      TestUser5.new(:csv => upload('support/3x6.csv')).should be_valid
    end
    
  end

  describe "row count validation" do
    
    class TestUser6 < TestModel
      validates :csv, :csv => {:rows => 6}
    end

    class TestUser7 < TestModel
      validates :csv, :csv => {:min_rows => 10}
    end

    class TestUser8 < TestModel
      validates :csv, :csv => {:min_rows => 6}
    end

    class TestUser9 < TestModel
      validates :csv, :csv => {:max_rows => 6}
    end
    
    it "should be valid with exact row count" do
      TestUser6.new(:csv => upload('support/3x6.csv')).should be_valid
    end

    it "should be invalid due to exact row count" do
      testUser = TestUser6.new(:csv => upload('support/3x7.csv'))
      testUser.should have(1).error_on(:csv)
      testUser.error_on(:csv)[0].should eq("should have 6 rows")
    end

    it "should be invalid due to min row count" do
      testUser = TestUser7.new(:csv => upload('support/3x6.csv'))
      testUser.should have(1).error_on(:csv)
      testUser.error_on(:csv)[0].should eq("should have at least 10 rows")      
    end

    it "should be valid with min row count" do
      TestUser8.new(:csv => upload('support/3x6.csv')).should be_valid
    end

    it "should be invalid due to max row count" do
      testUser = TestUser9.new(:csv => upload('support/3x7.csv'))
      testUser.should have(1).error_on(:csv)
      testUser.error_on(:csv)[0].should eq("should have no more than 6 rows")      
    end

    it "should be valid with max row count" do
      TestUser9.new(:csv => upload('support/3x6.csv')).should be_valid
    end
    
  end

  describe "content validation" do
    
    class TestUser10 < TestModel
      validates :csv, :csv => {:email => 1}
    end

    class TestUser11 < TestModel
      validates :csv, :csv => {:email => 0}
    end

    class TestUser12 < TestModel
      validates :csv, :csv => {:numericality => 2}
    end

    class TestUser13 < TestModel
      validates :csv, :csv => {:numericality => 0}
    end
    
    it "should be invalid with a column specified as containing only emails" do
      testUser = TestUser10.new(:csv => upload('support/3x6.csv'))
      testUser.should have(1).error_on(:csv)
      testUser.error_on(:csv)[0].should include("contains invalid emails")
    end

    it "should be valid with a column specified as containing only emails" do
      TestUser11.new(:csv => upload('support/3x6.csv')).should be_valid
    end

    it "should be valid with a column specified as containing only numbers" do
      TestUser12.new(:csv => upload('support/3x6.csv')).should be_valid
    end

    it "should be invalid with a column specified as containing only numbers" do
      testUser = TestUser13.new(:csv => upload('support/3x6.csv'))
      testUser.should have(1).error_on(:csv)
      testUser.error_on(:csv)[0].should include("contains non-numeric content in column 0")
    end
    
  end

end

