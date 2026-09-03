import React, { useRef, useState, useEffect } from "react";
import { motion } from "framer-motion";

export const SlideTabs = ({ 
  tabs = [
    { label: "Our Mission", href: "#mission" },
    { label: "Tri-Modal Platform", href: "#tri-modal" },
    { label: "Live AI Demo", href: "#simulator" },
    { label: "Ground Impact", href: "#impact" },
    { label: "Scholarships DB", href: "#scholarships" }
  ],
  activeIndex = 0,
  onTabSelect
}) => {
  const [position, setPosition] = useState({
    left: 0,
    width: 0,
    opacity: 0,
  });
  
  const [selected, setSelected] = useState(activeIndex);
  const tabsRef = useRef([]);

  // Sync external active index (from scroll-spy)
  useEffect(() => {
    setSelected(activeIndex);
  }, [activeIndex]);

  // Recalculate position when selected tab changes
  useEffect(() => {
    const selectedTab = tabsRef.current[selected];
    if (selectedTab) {
      const { width } = selectedTab.getBoundingClientRect();
      setPosition({
        left: selectedTab.offsetLeft,
        width,
        opacity: 1,
      });
    }
  }, [selected]);

  return (
    <ul
      onMouseLeave={() => {
        const selectedTab = tabsRef.current[selected];
        if (selectedTab) {
          const { width } = selectedTab.getBoundingClientRect();
          setPosition({
            left: selectedTab.offsetLeft,
            width,
            opacity: 1,
          });
        }
      }}
      className="relative flex items-center rounded-full border border-[#EBD1C6]/25 bg-[#2A1517]/90 p-1 backdrop-blur-md shadow-inner"
    >
      {tabs.map((tab, i) => (
        <Tab
          key={tab.label || tab}
          ref={(el) => (tabsRef.current[i] = el)}
          setPosition={setPosition}
          onClick={() => {
            setSelected(i);
            if (onTabSelect) onTabSelect(tab, i);
          }}
          href={tab.href}
          isSelected={selected === i}
        >
          {tab.label || tab}
        </Tab>
      ))}

      <Cursor position={position} />
    </ul>
  );
};

const Tab = React.forwardRef(({ children, setPosition, onClick, href, isSelected }, ref) => {
  const content = (
    <span className="relative z-10 block cursor-pointer px-3.5 py-1.5 text-xs font-bold tracking-wide transition-colors font-indic select-none whitespace-nowrap">
      {children}
    </span>
  );

  const handleMouseEnter = () => {
    if (!ref?.current) return;
    const { width } = ref.current.getBoundingClientRect();
    setPosition({
      left: ref.current.offsetLeft,
      width,
      opacity: 1,
    });
  };

  return (
    <li
      ref={ref}
      onClick={onClick}
      onMouseEnter={handleMouseEnter}
      className={`relative z-10 rounded-full transition-colors flex items-center justify-center ${
        isSelected ? 'text-[#3D2123]' : 'text-[#EBD1C6]/85 hover:text-white'
      }`}
    >
      {href ? (
        <a href={href} className="block text-inherit no-underline">
          {content}
        </a>
      ) : (
        content
      )}
    </li>
  );
});

Tab.displayName = "SlideTab";

const Cursor = ({ position }) => {
  return (
    <motion.li
      animate={{
        ...position,
      }}
      transition={{
        type: "spring",
        stiffness: 450,
        damping: 32,
      }}
      className="absolute z-0 h-7 sm:h-8 rounded-full bg-[#EBD1C6] shadow-sm pointer-events-none"
    />
  );
};

export default SlideTabs;
