package config

import (
	"errors"
	"fmt"
	"os"
	"strconv"
	"strings"

	"github.com/apex/log"
)

func (c *Config) Presets() []string {
	if c.UserPresets != nil {
		return c.UserPresets
	}

	return detectPresetsFromEnv()
}

func (c *Config) LoadPresets() error {
	presets := c.Presets()

	if len(presets) == 0 {
		return nil
	}

	log.WithField("context", "config").Infof("Load presets: %s", strings.Join(presets, ","))

	defaults := NewConfig()

	for _, preset := range presets {
		switch preset {
		case "fly":
			if err := c.loadFlyPreset(&defaults); err != nil {
				return err
			}
		case "heroku":
			if err := c.loadHerokuPreset(&defaults); err != nil {
				return err
			}
		case "broker":
			if err := c.loadBrokerPreset(&defaults); err != nil {
				return err
			}
		}
	}

	return nil
}

func (c *Config) loadFlyPreset(defaults *Config) error {
	if c.Host == defaults.Host {
		c.Host = "0.0.0.0"
	}

	region, ok := os.LookupEnv("FLY_REGION")

	if !ok {
		return errors.New("FLY_REGION env is missing")
	}

	appName, ok := os.LookupEnv("FLY_APP_NAME")

	if !ok {
		return errors.New("FLY_APP_NAME env is missing")
	}

	if c.EmbeddedNats.ServiceAddr == defaults.EmbeddedNats.ServiceAddr {
		c.EmbeddedNats.ServiceAddr = "nats://0.0.0.0:4222"
	}

	if c.EmbeddedNats.ClusterAddr == defaults.EmbeddedNats.ClusterAddr {
		c.EmbeddedNats.ClusterAddr = "nats://0.0.0.0:5222"
	}

	if c.EmbeddedNats.ClusterName == defaults.EmbeddedNats.ClusterName {
		c.EmbeddedNats.ClusterName = fmt.Sprintf("%s-%s-cluster", appName, region)
	}

	if c.EmbeddedNats.Routes == nil {
		c.EmbeddedNats.Routes = []string{fmt.Sprintf("nats://%s.%s.internal:5222", region, appName)}
	}

	if c.EmbeddedNats.GatewayAdvertise == defaults.EmbeddedNats.GatewayAdvertise {
		c.EmbeddedNats.GatewayAdvertise = fmt.Sprintf("%s.%s.internal:7222", region, appName)
	}

	if rpcName, ok := os.LookupEnv("ANYCABLE_FLY_RPC_APP_NAME"); ok {
		if c.RPC.Host == defaults.RPC.Host {
			c.RPC.Host = fmt.Sprintf("dns:///%s.%s.internal:50051", region, rpcName)
		}
	}

	return nil
}

func (c *Config) loadHerokuPreset(defaults *Config) error {
	if c.Host == defaults.Host {
		c.Host = "0.0.0.0"
	}

	if c.HTTPBroadcast.Port == defaults.HTTPBroadcast.Port {
		if herokuPortStr := os.Getenv("PORT"); herokuPortStr != "" {
			herokuPort, err := strconv.Atoi(herokuPortStr)
			if err != nil {
				return err
			}

			c.HTTPBroadcast.Port = herokuPort
		}
	}

	return nil
}

func (c *Config) loadBrokerPreset(defaults *Config) error {
	if c.BrokerAdapter == defaults.BrokerAdapter {
		c.BrokerAdapter = "memory"
	}

	redisEnabled := c.Redis.URL != defaults.Redis.URL
	enatsEnabled := c.EmbedNats

	if c.BroadcastAdapter == defaults.BroadcastAdapter {
		if redisEnabled {
			c.BroadcastAdapter = "http,redisx,redis"
		} else if enatsEnabled {
			c.BroadcastAdapter = "http,nats"
		} else {
			c.BroadcastAdapter = "http"
		}
	}

	if c.PubSubAdapter == defaults.PubSubAdapter {
		if redisEnabled || strings.Contains(c.BroadcastAdapter, "redis") {
			c.PubSubAdapter = "redis"
		} else if enatsEnabled {
			c.PubSubAdapter = "nats"
		}
	}

	return nil
}

func detectPresetsFromEnv() []string {
	presets := []string{}

	if isFlyEnv() {
		presets = append(presets, "fly")
	}

	if isHerokuEnv() {
		presets = append(presets, "heroku")
	}

	return presets
}

func isFlyEnv() bool {
	if _, ok := os.LookupEnv("FLY_APP_NAME"); !ok {
		return false
	}

	if _, ok := os.LookupEnv("FLY_ALLOC_ID"); !ok {
		return false
	}

	if _, ok := os.LookupEnv("FLY_REGION"); !ok {
		return false
	}

	return true
}

func isHerokuEnv() bool {
	if _, ok := os.LookupEnv("HEROKU_APP_ID"); !ok {
		return false
	}

	if _, ok := os.LookupEnv("HEROKU_DYNO_ID"); !ok {
		return false
	}

	return true
}
