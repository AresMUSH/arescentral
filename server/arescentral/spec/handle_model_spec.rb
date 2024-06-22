require_relative 'test_helper'

module AresCentral
  describe Handle do

    before do
      @handle = Handle.new      
      @handle.auth_token = nil   
      @handle.auth_token_expiry = nil
    end
    
    describe :is_valid_auth_token? do

      it "should fail if there is no token" do     
        @handle.auth_token = nil   
        expect(@handle.is_valid_auth_token?("123")).to eq false
      end 
      
      it "should fail if the token doesn't match" do     
        @handle.auth_token = "234"
        expect(@handle.is_valid_auth_token?("123")).to eq false
      end 
      
      it "should fail if there is no token expiry" do     
        @handle.auth_token = "123" 
        @handle.auth_token_expiry = nil
        expect(@handle.is_valid_auth_token?("123")).to eq false
      end 
      
      it "should fail if the token has expired" do     
        @handle.auth_token = "123"   
        @handle.auth_token_expiry = Time.now - 1000
        expect(@handle.is_valid_auth_token?("123")).to eq false
      end
      
      it "should succeed if the token matches and is not exipred" do     
        @handle.auth_token = "123"   
        @handle.auth_token_expiry = Time.now + 1000
        expect(@handle.is_valid_auth_token?("123")).to eq true
      end
    end 
    
    describe :check_name_requirements do
      it "should fail if name too short" do
        expect(Handle.check_name_requirements(nil)).to eq "Handle must be at least two characters long."
        expect(Handle.check_name_requirements("A")).to eq "Handle must be at least two characters long."
      end
      
      it "should fail if name too long" do
        expect(Handle.check_name_requirements("ABCDEABCDEABCDEABCDEF")).to eq "Handle must not be longer than 20 characters."
      end
    
      it "should fail if name has invalid characters" do
        expect(Handle.check_name_requirements("A-B")).to eq "Handle may contain only letters and numbers."
        expect(Handle.check_name_requirements("A B")).to eq "Handle may contain only letters and numbers."
      end
    
      it "should fail if handle is only numbers" do
        expect(Handle.check_name_requirements("1234")).to eq "Handle cannot be only numbers."
      end
      
      it "should be ok otherwise" do
        expect(Handle.check_name_requirements("A123")).to be_nil
        expect(Handle.check_name_requirements("AB")).to be_nil
        expect(Handle.check_name_requirements("ABCDEABCDEABCDEABCDE")).to be_nil
      end
    end
    
    describe :check_password_requirements do
      it "should fail if password too short" do
        expect(Handle.check_password_requirements(nil)).to eq "Minimum password length: 8 characters."
        expect(Handle.check_password_requirements("ABCDEAB")).to eq "Minimum password length: 8 characters."
      end
    
      it "should fail if password too long" do
        expect(Handle.check_password_requirements("ABCDEABCDEABCDEABCDEABCDE")).to eq "Maximum password length: 24 characters."
      end
      
      it "should fail if password is only numbers" do
        expect(Handle.check_password_requirements("11111111")).to eq "Password cannot be only numbers."
      end
      
      it "should fail if password has no letters or numbers" do
        expect(Handle.check_password_requirements("        ")).to eq "Password must contain letters or numbers."
      end
      
      it "should fail if password has an equals sign" do
        expect(Handle.check_password_requirements("ABCD=EFGH")).to eq "Password cannot contain the = sign."
      end
    
      it "should be ok otherwise" do
        expect(Handle.check_password_requirements("ABCDEABC")).to be_nil
        expect(Handle.check_password_requirements("ABC12345")).to be_nil
        expect(Handle.check_password_requirements("ABCDEABCDEABCDEABCDEABCD")).to be_nil
        
      end
    
    end
    
  end
end