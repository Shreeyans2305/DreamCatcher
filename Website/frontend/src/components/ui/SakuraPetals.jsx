import React, { useEffect, useRef } from 'react';

/**
 * SakuraPetals
 * Renders delicate, floating cherry blossom petals drifting across the canvas.
 * Highly performant 60fps canvas implementation with pointer-events-none.
 */
export default function SakuraPetals({ count = 28, speed = 1, opacity = 0.85, className = '' }) {
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

    // Petal color palette (soft blush, cherry blossom rose, creamy petal highlights)
    const petalColors = [
      'rgba(247, 187, 197, 0.75)',
      'rgba(242, 170, 182, 0.85)',
      'rgba(255, 204, 213, 0.70)',
      'rgba(235, 150, 165, 0.80)',
      'rgba(255, 222, 228, 0.65)'
    ];

    class Petal {
      constructor() {
        this.reset(true);
      }

      reset(init = false) {
        this.x = Math.random() * width;
        this.y = init ? Math.random() * height : -20;
        this.size = Math.random() * 8 + 6;
        this.color = petalColors[Math.floor(Math.random() * petalColors.length)];
        this.speedX = (Math.random() * 1.2 + 0.4) * speed;
        this.speedY = (Math.random() * 1.0 + 0.7) * speed;
        this.rotation = Math.random() * 360;
        this.rotationSpeed = (Math.random() * 1.5 - 0.75);
        this.swing = Math.random() * 2 * Math.PI;
        this.swingSpeed = Math.random() * 0.02 + 0.01;
        this.flip = Math.random() * Math.PI;
        this.flipSpeed = Math.random() * 0.03 + 0.01;
      }

      update() {
        this.swing += this.swingSpeed;
        this.flip += this.flipSpeed;
        this.rotation += this.rotationSpeed;

        this.x += this.speedX + Math.sin(this.swing) * 0.8;
        this.y += this.speedY;

        if (this.y > height + 25 || this.x > width + 25) {
          this.reset(false);
        }
      }

      draw() {
        ctx.save();
        ctx.translate(this.x, this.y);
        ctx.rotate((this.rotation * Math.PI) / 180);
        ctx.scale(Math.cos(this.flip), 1);

        ctx.fillStyle = this.color;
        ctx.beginPath();
        // Draw elegant teardrop-curved petal shape
        ctx.moveTo(0, 0);
        ctx.bezierCurveTo(this.size / 2, -this.size / 2, this.size, -this.size / 4, this.size, this.size / 2);
        ctx.bezierCurveTo(this.size, this.size, this.size / 2, this.size * 1.2, 0, this.size * 1.4);
        ctx.bezierCurveTo(-this.size / 2, this.size * 1.2, -this.size, this.size, -this.size, this.size / 2);
        ctx.bezierCurveTo(-this.size, -this.size / 4, -this.size / 2, -this.size / 2, 0, 0);
        ctx.fill();

        ctx.restore();
      }
    }

    const petals = Array.from({ length: count }, () => new Petal());

    const render = () => {
      ctx.clearRect(0, 0, width, height);
      petals.forEach((petal) => {
        petal.update();
        petal.draw();
      });
      animationFrameId = requestAnimationFrame(render);
    };

    render();

    return () => {
      window.removeEventListener('resize', handleResize);
      cancelAnimationFrame(animationFrameId);
    };
  }, [count, speed]);

  return (
    <canvas
      ref={canvasRef}
      className={`pointer-events-none absolute inset-0 w-full h-full overflow-hidden ${className}`}
      style={{ opacity }}
    />
  );
}
