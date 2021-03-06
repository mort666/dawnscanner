require 'spec_helper'
describe "The CVE-2015-3225 vulnerability" do
	before(:all) do
		@check = Dawn::Kb::CVE_2015_3225.new
		# @check.debug = true
	end
  it "is reported when vulnerable rack gem is used (1.5.3)" do
    @check.dependencies = [{:name=>"rack", :version=>'1.5.3'}]
    @check.vuln?.should   == true
  end
  it "is reported when vulnerable rack gem is used (1.6.1)" do
    @check.dependencies = [{:name=>"rack", :version=>'1.6.1'}]
    @check.vuln?.should   == true
  end
  it "is not reported when safe rack gem is used (1.5.4)" do
    @check.dependencies = [{:name=>"rack", :version=>'1.5.4'}]
    @check.vuln?.should   == false
  end
  it "is not reported when safe rack gem is used (1.5.5)" do
    @check.dependencies = [{:name=>"rack", :version=>'1.5.5'}]
    @check.vuln?.should   == false
  end
  it "is not reported when safe rack gem is used (1.6.3)" do
    @check.dependencies = [{:name=>"rack", :version=>'1.6.3'}]
    @check.vuln?.should   == false
  end
end
