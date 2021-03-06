defmodule Changelog.AgentKitTest do
  use ExUnit.Case

  alias Changelog.AgentKit

  describe "get_podcast_client/1" do
    test "returns 'Apple Watch' for known user agents" do
      ua = "(null)/(null) watchOS/5.0.1 model/Watch3,2 hwp/t8004 build/16R381 (6; dt:154)"
      assert AgentKit.get_podcast_client(ua) == "Apple Watch"
    end

    test "returns 'Apple Podcasts' if prefix is 'AppleCoreMedia'" do
      ua = "AppleCoreMedia/5.0.1 model/Watch3,2 hwp/t8004 build/16R381 (6; dt:154)"
      assert AgentKit.get_podcast_client(ua) == "Apple Podcasts"
    end

    test "returns everything before opening '/' otherwise" do
      ua = "LG-K428/V20l Player/LG Player 1.0 for Android 7.0"
      assert AgentKit.get_podcast_client(ua) == "LG-K428"
    end
  end

  describe "get_subscribers/1" do
    test "returns :error and :no_ua_string when sent nil" do
      assert {:error, :no_ua_string} = AgentKit.get_subscribers(nil)
    end

    test "returns :error and :no_subscribers when subscibers aren't detected" do
      agent = "Overcast/1.0 Podcast Sync (feed-id=554901; +http://overcast.fm/)"
      assert {:error, :no_subscribers} = AgentKit.get_subscribers(agent)
    end

    test "returns :error and :no_subscribers when sub count is 1 or less" do
      agent = "Overcast/1.0 Podcast Sync (1 subscribers; feed-id=554901; +http://overcast.fm/)"
      assert {:error, :no_subscribers} = AgentKit.get_subscribers(agent)
    end

    test "returns :error and :unknown_agent when agent isn't known" do
      agent = "Castro 2 Episode Download (1000 subscribers)"
      assert {:error, :unknown_agent} = AgentKit.get_subscribers(agent)
    end

    test "returns :ok and tuple with agent/subs when count is there and agent is known" do
      agent = "PlayerFM/1.0 Podcast Sync (5033 subscribers; url=https://player.fm/series/the-changelog-1282967)"
      assert {:ok, {"PlayerFM", 5033}} = AgentKit.get_subscribers(agent)
    end

    test "returns :ok and tuple with agent/subs with case insensitive match" do
      agent = "Mozilla/5.0 (compatible; inoreader.com; 25 subscribers)"
      assert {:ok, {"Inoreader", 25}} = AgentKit.get_subscribers(agent)
    end
  end
end
