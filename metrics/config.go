package metrics

// Config contains metrics configuration
type Config struct {
	Log          bool
	LogInterval  int
	LogFormatter string
	HTTP         string
	Host         string
	Port         int
}

// NewConfig creates an empty Config struct
func NewConfig() Config {
	return Config{}
}

// LogEnabled returns true iff Log is true
func (c *Config) LogEnabled() bool {
	return c.Log || c.LogFormatterEnabled() || c.LogInterval > 0
}

// HTTPEnabled returns true iff HTTP is not empty
func (c *Config) HTTPEnabled() bool {
	return c.HTTP != ""
}

// LogFormatterEnabled returns true iff LogFormatter is not empty
func (c *Config) LogFormatterEnabled() bool {
	return c.LogFormatter != ""
}
