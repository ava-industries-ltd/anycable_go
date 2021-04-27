package metrics

import "github.com/apex/log"

// Printer describes metrics logging interface
type Printer interface {
	Print(snapshot map[string]int64)
}

// BasePrinter simply logs stats as structured log
type BasePrinter struct {
	interval int
}

// NewBasePrinter returns new base printer struct
func NewBasePrinter(interval int) *BasePrinter {
	return &BasePrinter{interval}
}

// Run prints a message to the log with metrics logging details
func (p *BasePrinter) Run() error {
	log.WithField("context", "metrics").Infof("Log metrics every %ds", p.interval)
	return nil
}

func (p *BasePrinter) Stop() {
}

// Write prints formatted snapshot to the log
func (p *BasePrinter) Write(m *Metrics) error {
	snapshot := m.IntervalSnapshot()
	p.Print(snapshot)
	return nil
}

// Print logs stats data using global logger with info level
func (*BasePrinter) Print(snapshot map[string]int64) {
	fields := make(log.Fields, len(snapshot)+1)

	fields["context"] = "metrics"

	for k, v := range snapshot {
		fields[k] = v
	}

	log.WithFields(fields).Info("")
}
