import React, { useEffect, useRef } from 'react';

/**
 * DreamCatcherWind
 * A serene animation component for DreamCatcher:
 * - Floating, fluttering feathers carried by a gentle horizontal breeze
 * - Swaying woven dreamcatchers with dangling beads and feathers
 * - Soft luminous wind dust particles
 * - 60fps HTML5 Canvas with pointer-events-none
 */
export default function DreamCatcherWind({
  showDreamcatchers = true,
  featherCount = 18,
  windSpeed = 1,
  opacity = 0.9,
  className = ''
}) {
  const canvasRef = useRef(null);

  useEffect(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    let animationFrameId;

    let width = (canvas.width = canvas.offsetWidth);
    let height = (canvas.height = canvas.offsetHeight);

    const handleResize = () => {
      if (!canvas) return;
      width = canvas.width = canvas.offsetWidth;
      height = canvas.height = canvas.offsetHeight;
    };

    window.addEventListener('resize', handleResize);

    // Natural feather colors (warm parchment, soft cream, sage green tint, turquoise bead, dusty rose)
    const featherColors = [
      { base: 'rgba(235, 225, 212, 0.85)', vein: 'rgba(180, 165, 148, 0.9)' },
      { base: 'rgba(215, 200, 185, 0.80)', vein: 'rgba(160, 145, 130, 0.85)' },
      { base: 'rgba(242, 236, 226, 0.90)', vein: 'rgba(195, 180, 162, 0.9)' },
      { base: 'rgba(210, 222, 215, 0.75)', vein: 'rgba(145, 165, 155, 0.85)' },
      { base: 'rgba(238, 215, 210, 0.80)', vein: 'rgba(185, 155, 150, 0.85)' }
    ];

    // Feather particle in wind
    class Feather {
      constructor(init = false) {
        this.reset(init);
      }

      reset(init = false) {
        this.x = init ? Math.random() * width : -40;
        this.y = Math.random() * height;
        this.length = Math.random() * 22 + 16;
        this.width = this.length * 0.28;
        this.color = featherColors[Math.floor(Math.random() * featherColors.length)];
        
        // Gentle horizontal wind velocity with vertical drift
        this.speedX = (Math.random() * 1.5 + 0.8) * windSpeed;
        this.speedY = (Math.random() * 0.5 - 0.2) * windSpeed;
        
        // Flutter & rotation
        this.angle = Math.random() * 360;
        this.angleSpeed = (Math.random() * 0.8 - 0.4);
        this.flutter = Math.random() * Math.PI * 2;
        this.flutterSpeed = Math.random() * 0.03 + 0.015;
        this.tilt = Math.random() * Math.PI;
        this.tiltSpeed = Math.random() * 0.02 + 0.01;
      }

      update() {
        this.flutter += this.flutterSpeed;
        this.tilt += this.tiltSpeed;
        this.angle += this.angleSpeed;

        this.x += this.speedX + Math.sin(this.flutter) * 0.7;
        this.y += this.speedY + Math.cos(this.flutter * 0.8) * 0.5;

        if (this.x > width + 50 || this.y < -50 || this.y > height + 50) {
          this.reset(false);
        }
      }

      draw() {
        ctx.save();
        ctx.translate(this.x, this.y);
        ctx.rotate((this.angle * Math.PI) / 180);
        ctx.scale(Math.cos(this.tilt), 1);

        // Feather shaft
        ctx.strokeStyle = this.color.vein;
        ctx.lineWidth = 1;
        ctx.beginPath();
        ctx.moveTo(-this.length * 0.5, 0);
        ctx.quadraticCurveTo(0, this.width * 0.15, this.length * 0.5, 0);
        ctx.stroke();

        // Feather vanes / body
        ctx.fillStyle = this.color.base;
        ctx.beginPath();
        ctx.moveTo(-this.length * 0.5, 0);
        ctx.bezierCurveTo(
          -this.length * 0.2, -this.width * 0.9,
          this.length * 0.2, -this.width * 0.8,
          this.length * 0.5, 0
        );
        ctx.bezierCurveTo(
          this.length * 0.2, this.width * 0.7,
          -this.length * 0.2, this.width * 0.8,
          -this.length * 0.5, 0
        );
        ctx.fill();

        ctx.restore();
      }
    }

    // Swaying Hanging Dreamcatcher on Canvas
    class SwayingDreamcatcher {
      constructor(anchorX, anchorY, radius, stringLength) {
        this.anchorX = anchorX;
        this.anchorY = anchorY;
        this.radius = radius;
        this.stringLength = stringLength;
        this.angle = (Math.random() * 0.08 - 0.04);
        this.angularVelocity = 0;
        this.angularAcceleration = 0;
        this.phase = Math.random() * Math.PI * 2;
      }

      update(time) {
        // Wind gusts and natural harmonic pendulum motion
        const windForce = Math.sin(time * 0.0015 + this.phase) * 0.0006 * windSpeed;
        const gravity = 0.0008;
        this.angularAcceleration = (-gravity * Math.sin(this.angle)) + windForce;
        this.angularVelocity += this.angularAcceleration;
        this.angularVelocity *= 0.985; // Air damping
        this.angle += this.angularVelocity;
      }

      draw() {
        ctx.save();
        ctx.translate(this.anchorX, this.anchorY);
        ctx.rotate(this.angle);

        // Hanging string
        ctx.strokeStyle = 'rgba(120, 100, 80, 0.4)';
        ctx.lineWidth = 1.2;
        ctx.beginPath();
        ctx.moveTo(0, 0);
        ctx.lineTo(0, this.stringLength);
        ctx.stroke();

        const hoopCenterY = this.stringLength + this.radius;

        // Outer wooden hoop
        ctx.strokeStyle = 'rgba(140, 105, 75, 0.85)';
        ctx.lineWidth = 2.5;
        ctx.beginPath();
        ctx.arc(0, hoopCenterY, this.radius, 0, Math.PI * 2);
        ctx.stroke();

        // Inner sacred webbing (8-point star web)
        ctx.strokeStyle = 'rgba(175, 150, 125, 0.45)';
        ctx.lineWidth = 0.8;
        const points = 8;
        ctx.beginPath();
        for (let i = 0; i < points; i++) {
          const a1 = (i * Math.PI * 2) / points;
          const a2 = ((i + 3) * Math.PI * 2) / points;
          ctx.moveTo(Math.cos(a1) * this.radius, hoopCenterY + Math.sin(a1) * this.radius);
          ctx.lineTo(Math.cos(a2) * this.radius, hoopCenterY + Math.sin(a2) * this.radius);
        }
        ctx.stroke();

        // Center turquoise bead
        ctx.fillStyle = '#40A8A0';
        ctx.beginPath();
        ctx.arc(0, hoopCenterY, 3, 0, Math.PI * 2);
        ctx.fill();

        // 3 Dangling strands with feathers at the bottom
        const strands = [-this.radius * 0.5, 0, this.radius * 0.5];
        strands.forEach((sx, idx) => {
          const strandLen = this.radius * (idx === 1 ? 1.4 : 1.0);
          const startY = hoopCenterY + this.radius;
          
          // Strand thread
          ctx.strokeStyle = 'rgba(120, 100, 80, 0.5)';
          ctx.lineWidth = 1;
          ctx.beginPath();
          ctx.moveTo(sx, startY);
          const endY = startY + strandLen;
          ctx.lineTo(sx, endY);
          ctx.stroke();

          // Bead
          ctx.fillStyle = idx === 1 ? '#D28E7D' : '#40A8A0';
          ctx.beginPath();
          ctx.arc(sx, endY - 6, 2, 0, Math.PI * 2);
          ctx.fill();

          // Dangling feather fluttering
          ctx.save();
          ctx.translate(sx, endY);
          ctx.rotate(Math.sin(this.angle * 2 + idx) * 0.2);

          ctx.fillStyle = 'rgba(240, 230, 218, 0.85)';
          ctx.beginPath();
          ctx.moveTo(0, 0);
          ctx.bezierCurveTo(4, 8, 5, 18, 0, 24);
          ctx.bezierCurveTo(-5, 18, -4, 8, 0, 0);
          ctx.fill();

          ctx.strokeStyle = 'rgba(160, 140, 120, 0.7)';
          ctx.lineWidth = 0.8;
          ctx.beginPath();
          ctx.moveTo(0, 0);
          ctx.lineTo(0, 22);
          ctx.stroke();

          ctx.restore();
        });

        ctx.restore();
      }
    }

    const feathers = Array.from({ length: featherCount }, () => new Feather(true));
    
    // Create two subtle swaying dreamcatchers near the top right if requested
    const dreamcatchers = showDreamcatchers ? [
      new SwayingDreamcatcher(width * 0.72, -10, 32, 60),
      new SwayingDreamcatcher(width * 0.86, -15, 24, 45)
    ] : [];

    let startTime = performance.now();

    const render = (time) => {
      ctx.clearRect(0, 0, width, height);

      // Draw dreamcatchers
      dreamcatchers.forEach(dc => {
        dc.update(time);
        dc.draw();
      });

      // Draw floating wind feathers
      feathers.forEach(f => {
        f.update();
        f.draw();
      });

      animationFrameId = requestAnimationFrame(render);
    };

    animationFrameId = requestAnimationFrame(render);

    return () => {
      window.removeEventListener('resize', handleResize);
      cancelAnimationFrame(animationFrameId);
    };
  }, [showDreamcatchers, featherCount, windSpeed]);

  return (
    <canvas
      ref={canvasRef}
      className={`pointer-events-none absolute inset-0 w-full h-full overflow-hidden ${className}`}
      style={{ opacity }}
    />
  );
}
